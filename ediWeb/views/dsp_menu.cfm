

<table>
<cfoutput query="batchinfo">
<tr>
<td><a href="#myself##xfa.viewOrders#&shortName=#shortName#&status=#status#&batchid=#batchid#">#batchid#</a></td>
<td>#shortName#</td><td>#longdesc#</td><td><a href="#myself##xfa.email#&shortName=#shortName#&status=#status#&batchid=#batchid#">email</a></td>
</tr>
</cfoutput>
<tr><td><cfoutput><a href="#myself##xfa.createCSVFile#"></cfoutput>Create Flat File</a></td>
</table>

