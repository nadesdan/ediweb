<cfcomponent>

	<cffunction name="init" access="public" returntype="email" output="false" hint="Constructor.">
			<cfreturn this />
	</cffunction>	


	<cffunction name="emailNewOrders" access="public" returntype="string">
		
      		<cfargument name="to" type="string" required="yes">
            <cfargument name="from" type="string" required="yes" default="edi@sbacher.co.za">
        	<cfargument name="cc" type="string" required="yes">
            <cfargument name="qry" type="query" required="yes">
            
            <cfmail to="#arguments.to#" 
            from="#arguments.from#" 
            subject="new orders (batch #qry.batchid#) have arrived" 
            cc="#arguments.cc#" 
            type="html" 
            query="qry">
            
            <html>
            <head>
            <title>Untitled Document</title>
            <style type="text/css">
            TD{
                font-size: 10px;
                font-family : Arial, sans-serif;
            }
            TR{
                font-size: 10px;
                font-family : Arial, sans-serif;
            } 
            TABLE.border{
                border : thin solid Aqua;
            }
            .bold
            {
                font-weight: bold;
            }</style>
            </head>
            <body>
            <table border="0">
            
              
            <cfoutput group="ordernumber">
            <tr bgcolor="33FFFF">
            <td colspan="2">Order: #orderNumber#</td> 
            <td>#storeName#</td> 
            <tr bgcolor="33FFFF">
            <td>Date: #Dateformat(orderDate,"mmm-dd-yy")#</td> 
            <td>Before: #Dateformat(beforeDate,"mmm-dd-yy")#</td> 
            <td>After: #Dateformat(afterDate,"mmm-dd-yy")#</td>
            </tr>
            <tr><td colspan="3">
            <table width="400" class="border" >
            <tr><td><strong>Barcode</strong></td>
            <td><strong>Item</strong></td>
            <td><strong>Desc</strong></td>
            <td><strong>Qty</strong></td>
            <td><strong>Cost</strong></td></tr>
            <cfoutput>                
            
            <tr>
            <td>#productEAN#</td>
            <td>#itemno#</td>
            <td>#itemdesc#</td>
            <td>#qty#</td>
            <td>#totalcost#</td></tr>
            
            </cfoutput>
            </table></td></tr>
            <tr><td colspan="3"><hr /></td></tr>
            
            </cfoutput> 
            </table>
            
            </body>
            
            </cfmail>
        
	</cffunction>
</cfcomponent>


