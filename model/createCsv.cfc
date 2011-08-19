<cfcomponent displayname="importFile">

<cffunction name="init" access="public" returntype="createCsv" output="false" hint="Constructor. i am">
	<cfargument name="dsn" type="string" required="yes">
			<cfset variables.dsn = arguments.dsn>		
			<cfreturn this />
	</cffunction>	

<cffunction name="create" access="public" returntype="string">


<cftransaction>
<cfquery name="createCsv" datasource="#variables.dsn#">select
RTRIM(h.orderID) as orduniq,
RTRIM(h.orderNumber) as ponumber,
RTRIM(h.storeCode) as customer,
RTRIM(h.batchID) as batchid,
h.vatstatus as vatstatus,
h.orderDate as orddate,
DateAdd(day,-1,h.afterDate) as shpdate,
RTRIM(d.line) as linenum,
RTRIM(d.itemNo) as item,
d.qtyShipped as QTYORDERED,
d.qtyShipped as QTYSHIPPED,
d.unitCost as PRIUNTPRC
from ediHeader h
inner join ediDetail d on h.orderID = d.orderID
where h.status = 3
and d.qtyShipped > 0
order by h.batchid, h.vatStatus, h.storeCode</cfquery><cfsavecontent variable="content"><cfoutput>"RECTYPE","ORDUNIQ","CUSTOMER","ORDDATE","EXPDATE","PONUMBER","REFERENCE","POSTINV"
"RECTYPE","ORDUNIQ","LINENUM","ITEM","QTYORDERED","QTYSHIPPED","PRIUNTPRC"
"RECTYPE","ORDUNIQ","LINENUM","SERIALNUMF"
"RECTYPE","ORDUNIQ","LINENUM","LOTNUMF"
"RECTYPE","ORDUNIQ","PAYMENT"
"RECTYPE","ORDUNIQ","UNIQUIFIER"
"RECTYPE","ORDUNIQ","OPTFIELD","VALUE"
</cfoutput>
<cfoutput query="createCsv" group="orduniq">"1",#ORDUNIQ#,"#CUSTOMER#","#dateformat(now(),"YYYYMMDD")#",#dateformat(SHPDATE,"YYYYMMDD")#,"#PONUMBER#","#left(customer,3)#-#batchID#","0"#chr(13)##chr(10)#<cfoutput>"2",#ORDUNIQ#,#LINENUM#,"#ITEM#",#QTYORDERED#,<!--- #QTYSHIPPED# --->0,<cfif vatstatus eq 1>#NumberFormat(PRIUNTPRC*1.14,".00")#<cfelse>#PRIUNTPRC#</cfif>#chr(13)##chr(10)#</cfoutput>"5",#ORDUNIQ#,32#chr(13)##chr(10)#"7",#ORDUNIQ#,"REP","WAREHOUSE"#chr(13)##chr(10)#</cfoutput>
</cfsavecontent>

<cfif createCsv.recordcount eq 0>
	<cfset content = "">
<cfelse>

<cfquery name="updateStatus" datasource="#variables.dsn#">
update ediHeader
set status = 4
where orderid in (<cfloop query="createCsv">#orduniq#,</cfloop>0)
</cfquery>

</cfif>

</cftransaction>

<cfreturn content>

</cffunction>
</cfcomponent>