


<cfoutput><a href="#myself##xfa.viewOrders#&shortName=#shortName#&status=#status#&batchid=#batchid#"></cfoutput>Info</a>

<cfset format = "yes">
<table bordercolor="#0000CC">
<tr>
	<td>StoreCode</td>
	<td>Store Name</td>
	<td>QtyOrdered</td>
	<td>Value</td>
	<td>Cost</td>
	<td>After Date</td>
</tr>


<cfoutput  query="storeInfo">


<tr>
<td align="left">#storecode#</td>
<td align="left">#storename#</td>
<td align="right">#NumberFormat(QtyOrdered,",")#</td>
<td align="right">#NumberFormat(totalcost,",")#</td>
<td align="right">#NumberFormat(cost,",")#</td>
<td>#afterDate#</td>
</tr>

</cfoutput>

</table>

