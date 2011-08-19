<cfcomponent name="ediImport" hint="this component imports an EDI structure into a database">

	<cffunction name="init" access="public" returntype="ediImport" output="false" hint="Constructor.">		
		<cfargument name="dsn" type="string" required="yes">
			<cfset variables.dsn = arguments.dsn>		
			<cfreturn this />
	</cffunction>	

	<cffunction access="public" name="import" returntype="numeric">
	
		<cfargument name="result" type="struct" required="yes">

		<!--- create a new batchid --->
		<cfquery name="batch" datasource="#variables.dsn#">
		select max(batchID)+1 as batchid from ediHeader
		</cfquery>
		
        <!--- set batchid to 1 if first batch--->
		<cfif batch.batchid eq "">
			<cfset batch.batchid = 1>
		</cfif>
	    	
		<cftransaction>
	    
    		<!--- pull result from parse cfc--->
			<cfloop collection="#result#" item="z">
	
        		<!--- check if order has been imported by comparing ordernumber and store--->	
                <cfquery name="test" datasource="edi">
                    select orderNumber
                    from ediHeader 
                    where (orderNumber  = '#result[z].orderNumber#'
                    and storeEAN = '#result[z].storeid#')		
                </cfquery>
			
				<cfif test.recordcount eq 0>	
    
    			<!--- create an orderid --->
                <cfquery name="max" datasource="edi">
                select max(orderID)+1 maxid from ediHeader
                </cfquery>
	
    			<!--- set orderid to 1 if first order--->
				<cfif max.maxid eq "">
                    <cfset max.maxid = 1>
                </cfif>	
    
    			<!--- generate order headers from parsed result--->
                <cfquery name="header" datasource="edi">
                INSERT INTO ediHeader(orderID, batchID, customerEAN, storeEAN, orderNumber, orderDate, beforeDate, afterDate)
                VALUES(#max.maxid#, #batch.batchid#, '#result[z].customerID#', '#result[z].storeid#', '#result[z].orderNumber#', 
                #result[z].orderDate#,
                #result[z].beforeDate#,
                #result[z].afterDate#)
                </cfquery>	
    
    			<!--- generate order detail lines --->
				<cfset length = arrayLen(result[z].orderDetails)>	
    
    				<!--- loop through detail lines --->
				<cfloop from="1" to="#length#" index="x">	        
	        		<!--- generate each order detail from parsed result--->
					<cfquery name="detail" datasource="edi">
	                        INSERT INTO ediDetail(orderID, line, productEAN, qty, unitCost, totalCost, retail)
	                        VALUES(#max.maxid#, #x#, '#result[z].orderDetails[x][1]#', #result[z].orderDetails[x][3]#, #result[z].orderDetails[x][4]#, #result[z].orderDetails[x][5]#, #result[z].orderDetails[x][6]#)
	                </cfquery>				
				</cfloop> 
			</cfif>
			
			</cfloop>

			</cftransaction> 

<cfreturn batch.batchid>

</cffunction>
</cfcomponent>