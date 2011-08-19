<cfcomponent>

	<cffunction name="init" access="public" returntype="ediQuery" output="false" hint="Constructor.">
			<cfargument name="dsn" type="string" required="yes">
			<cfset variables.dsn = arguments.dsn>		
			<cfreturn this />
	</cffunction>	

		<cffunction name="qryItemSummary" returntype="query">
	
		<cfargument name="shortName" type="string" required="yes">	
		<cfargument name="status" type="numeric" required="yes">	
        <cfargument name="batchid" required="no">
        
		<cfquery name="qryItemSummary" datasource="#variables.dsn#">
			Select 
            RTRIM(d.itemNo) as Itemno, 
            RTRIM(d.productEAN) as barcode, 
			RTRIM(m."DESC") as "Description", 
			RTRIM(m.CATEGORY) as category, 
			sum(d.qty) as QtyOrdered, 
			ROUND((i.QTYONHAND-i.QTYSHNOCST+i.QTYRENOCST+i.QTYADNOCST),0) as QTYONHAND, 
			i.QTYCOMMIT, 
			sum(d.qtyShipped) as qtyshipped,
			d.unitCost as unitcost,  
			sum(d.qty) * d.unitCost as totalcost, 
			d.retail as storeretail, 
			p.UNITPRICE as unitprice, 
			c.shortName,
			ds.PRCNTLVL2/100 as B, 
			ds.PRCNTLVL3/100 as C, 
			gp =
				CASE 
					when unitprice > 0 then ROUND(1-(d.unitCost/(p.UNITPRICE/1.14)),4)
					when unitprice = 0 then 0 
				END
			from ediHeader h
			inner join ediDetail d on h.orderID = d.orderID
			left outer join (select * from SBADAT.dbo.ICILOC where LOCATION = '2') i on d.itemNo = i.ITEMNO
			left outer join SBADAT.dbo.ICITEM m on d.itemNo = m.ITEMNO
			left outer join (select * from SBADAT.dbo.ICPRICP where dpricetype = 1) p on d.itemNo = p.ITEMNO
            left outer join SBADAT.dbo.ICPRIC ds on d.itemNo = ds.ITEMNO
			left outer join customers c on h.customerEAN = c.customerEAN
			where h.status = #arguments.status# and c.shortName = '#UCASE(arguments.shortName)#'
            <cfif len(batchid)>
           	 and batchid = #arguments.batchid#
            </cfif>            
             group by m.CATEGORY, d.itemNo, d.productEAN, m."DESC",  d.unitCost, d.retail, c.shortName,
			i.QTYONHAND, 
			i.QTYSHNOCST,
			i.QTYRENOCST,
			i.QTYADNOCST,
			i.QTYCOMMIT, 
			p.UNITPRICE,
			ds.PRCNTLVL2,
			ds.PRCNTLVL3
		</cfquery>
		
		<cfreturn qryItemSummary>
			
			
	</cffunction>	
		
		<cffunction name="qryStoreSummary" returntype="query">
		
		<cfargument name="shortName" type="string" required="yes">	
		<cfargument name="status" type="numeric" required="yes">	
        <cfargument name="batchid" required="no">
        
		<cfquery name="qryStoreSummary" datasource="#variables.dsn#">
			Select h.storeCode, h.storeName, h.afterDate,
			sum(d.qty) as QtyOrdered, 			
			sum(d.qty * d.unitCost) as totalcost, 		
			sum(d.qty * l.cost) as cost
			from ediHeader h
			inner join ediDetail d on h.orderID = d.orderID		
			left outer join SBADAT.dbo.ICITEM m on d.itemNo = m.ITEMNO
			left outer join (select ITEMNO, cost = case when qtyonhand > 0 
					then (totalcost/qtyonhand) else 0 end 
			from SBADAT.dbo.ICILOC where LOCATION = '2') l on d.itemNo = l.ITEMNO		
			left outer join customers c on h.customerEAN = c.customerEAN
			where h.status = #arguments.status# and c.shortName = '#UCASE(arguments.shortName)#'         
           	 <cfif len(batchid)>
           	 and batchid = #arguments.batchid#
            </cfif> 
                  
            group by  h.storeCode, h.storeName, h.afterDate
			order by storecode
		</cfquery>
		
		<cfreturn qryStoreSummary>
			
		</cffunction>
		
		<cffunction name="autoProcess">
	
               <cfargument name="batchid" type="numeric" required="yes">
                    
                <cfstoredproc procedure="allocateBatch" datasource="#variables.dsn#">                	
                      <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@batchid" value="#arguments.batchid#" null="no" >
                </cfstoredproc>                

		</cffunction>
	
    	<cffunction name="qryEmail" returntype="query">
        
            <cfargument name="status" type="numeric" required="yes">
            <cfargument name="batchid" type="numeric" required="no">
            
                <cfquery name="qryEmail" datasource="edi">
                select h.orderNumber, 
                h.customerEAN, 
                h.storeEAN, 
                h.storeName, 
                h.orderDate, 
                h.beforeDate, h.afterDate, 
                h.batchid,
                d.productEAN,
                d.itemno,
                d.itemdesc,
                d.qty, d.totalcost
                from ediHeader h
                inner join ediDetail d on h.orderid = d.orderid
                where h.status = #arguments.status#
                <cfif len(batchid)>
                  and batchid = #arguments.batchid#
                </cfif>  
                order by h.ordernumber
                </cfquery>
                
            <cfreturn qryEmail>
						
		</cffunction>
		
    	<cffunction name="updateStatus">              	
		
			<cfargument name="statusFrom" type="numeric" required="yes">
       		<cfargument name="statusTo" type="numeric" required="yes">
        	
                <cfquery name="updateStatus" datasource="edi">
                update ediHeader
                set status = #arguments.statusTo#
                where status = #arguments.statusFrom#             
                </cfquery>
							
			</cffunction>        
      	
    		<cffunction name="qryBatch">        
  			
                <cfquery name="BatchInfo" datasource="edi">
                select distinct s.status, s.longdesc, batchid, rtrim(c.shortName) as shortName
                from ediheader h
                inner join customers c on h.customerEAN = c.customerEAN
                right outer join status s on h.status = s.status
                where s.status in (0,1,2,3) and c.shortName in ('edg','fos')
                </cfquery>
            
            <cfreturn batchinfo>
							
		</cffunction>	
        
     <cffunction name="cancelInt">              	
		<cfargument name="batchid" type="numeric" required="yes">
			<cfquery name="cancelInt" datasource="edi">
                update ediheader
                set status = 7
                where status = 1 and vatStatus = 2  and batchid = #arguments.batchid#        
            </cfquery>
							
	</cffunction>     
	
	<cffunction name="isolateInt">              	
		<cfargument name="batchid" type="numeric" required="yes">
			<cfquery name="isolateInt" datasource="edi">
                update ediheader
                set batchid = (select max(batchid) + 1 from ediheader)
                where status = 1 and vatStatus = 2  and batchid = #arguments.batchid#    
            </cfquery>
							
	</cffunction>           
	
</cfcomponent>