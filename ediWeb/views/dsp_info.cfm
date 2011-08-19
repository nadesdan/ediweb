


<cfoutput><a href="#myself##xfa.viewStoreInfo#&shortName=#shortName#&status=#status#&batchid=#batchid#"></cfoutput>Store Info</a>

<cfset format = "yes">
<table bordercolor="#0000CC">
<tr>
<td>Item</td><td>Barcode</td><td>Descrip</td><td>QtyOrder</td>
<td>QtyAvail</td><td>QtyShip</td><td>UnitCost</td><td>TotalCost</td><td>Retail</td><td>SB-GP</td><td>CalcGP</td>
</tr>

<cfform method="post" preloader="no" format="html">




<cfoutput query="itemInfo" group="category">
<cfset tqty = "0">
<cfset tshp = "0">
<cfset tcost = "0">
<tr><td colspan="11">#category#</td></tr>
<cfoutput>
<cfset format = "yes">
<cfif itemno eq "" or qtyonhand eq "">
	<cfset format = "no">
</cfif>
<tr <cfif format neq "no"><cfif QtyOrdered gt (QTYONHAND-QTYCOMMIT)> bgcolor="##CCFF33" </cfif><cfelse>bgcolor="##CCFF33" </cfif>>
<td align="left">#Itemno#</td>
<td align="left">#barcode#</td>
<td align="left" nowrap>#Description#</td>
<td align="right">#NumberFormat(QtyOrdered,",")#</td>
<td align="right"><cfif format neq "no">#NumberFormat(QTYONHAND-QTYCOMMIT,",")#</cfif></td>
<td align="right"><cfif format neq "no">#NumberFormat(QtyShipped,",")#</cfif></td>
<td align="right">#NumberFormat(unitCost,",.00")#</td>
<td align="right">#NumberFormat(totalcost,",.00")#</td>
<td align="right"><cfif format neq "no">#NumberFormat(UNITPRICE,",.00")#</cfif></td>
<td align="right">
<cfif unitprice gt 0>
	<cfif trim(shortName) is 'EDG'>#NumberFormat(C*100,",.0")#%
    <cfelseif trim(shortName) is 'FOS'>#NumberFormat(B*100,",.0")#%
	</cfif>
</cfif>
</td>
<td align="right">
<cfif  gp gt 0>#NumberFormat(gp*100,",.0")#%</cfif></td>
</tr>
<cfset tqty = tqty + QtyOrdered>

<cfset tcost= tcost + totalcost></cfoutput>
<tr><td colspan="2"></td>
<td align="right">#NumberFormat(tqty,",")#</td>
<td></td>
<td align="right">#NumberFormat(tshp,",")#</td>
<td colspan="2"></td><td align="right">#NumberFormat(tcost,",.00")#</td>
</tr>
</cfoutput>
</cfform>
</table>
<cfoutput><a href="#myself##xfa.autoProcess#&batchid=#batchid#">Process Auto</a></cfoutput>
