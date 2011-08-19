
<table>
<tr>
<td>store</td><td>Name</td><td>Brand</td><td>Item</td>
<td>Description</td><td>QtyOrder<td>QtyShip</td>
</tr>

<cfform method="post" preloader="no" format="html">

<cfoutput query="itemQty">
<tr>
<td>#storeCode#</td>
<td>#storeName#</td>
<td>#category#</td>
<td align="left">#Itemno#</td>
<td align="left" nowrap>#Description#</td>
<td align="right">#NumberFormat(QtyOrdered,",")#</td>
<td align="right"><input name="qtyShipped" type="text" value="#NumberFormat(QtyShipped,",")#" size="1" /></td>
</tr></cfoutput>

</table>

</cfform>