  		
		
		
		
		<cffile action="read" file="C:\Inetpub\wwwroot\ediWeb\edi-files\test.edi" variable="edi">
		
  
  		<cfset feed = chr(10)&chr(13)>
        <cfset temp = replaceList(edi,feed,"")>
        
        
        
      
        
        <cfset temp = replaceList(temp,"'UNH","*")>
        
      
        <cfset temp = replaceList(temp,"UNH","*")>
        
        
        <cfset ix = ListGetAt(temp,1,"*")>                    
          <cfoutput> #ix#</cfoutput>
        
        
        <cfset temp = ListDeleteAt(temp,1,"*")>                    
        <cfset OrderArray = ListToArray(temp,"*")>        
        <cfset OrderCount = ArrayLen(OrderArray)>                                
        <cfset Orders = StructNew()>
        
        <cfdump var="#orderArray#">
        
 	 <cfloop from="1" to="#OrderCount#" index="x">  
        
        <cfset currLine = trim(OrderArray[x])>        
            <cfset LineArray = "">
            <cfset LineArray = ListToArray(OrderArray[x], "'")>
            <cfset LineCount = ArrayLen(LineArray)>	
            <cfset OrderContent = structNew()>
            <cfset customerID = "">
            <cfset storeID = "">
            <cfset orderNumber = "">
            <cfset orderDate = "">
            <cfset beforeDate = ""> 
            <cfset afterDate = "">
            <cfset orderDetails = arrayNew(2)>
        
   
        	
            	<cfloop from="1" to="#LineCount#" index="i">
                                    
                	<cfset currLine = trim(LineArray[i])>                                              
                                                                                                
                    <!--- supplier ean number and store ean number --->
                    <cfif left(currLine, 3) eq "CLO">
                        <cfset customerID = ListGetAt(currLine,4,"+")>
                        <cfset storeID = ListGetAt(currLine,2,"+")>			
                    </cfif>

                    <!--- order number and order date --->
                    <cfif left(currLine, 3) eq "ORD">									
                        <cfset orderNumber = ListGetAt(ListGetAt(currLine,2,"+"),1,":")>
                        <cfset orderDate = ListGetAt(ListGetAt(currLine,2,"+"),2,":")>
                    </cfif>
                    
                    <!---  not before and not after dates --->	
                    <cfif left(currLine, 3) eq "DIN">
                        <cfset beforeDate = ListGetAt(currLine,2,"+")>
                        <cfset afterDate = ListGetAt(currLine,3,"+")>
                    </cfif>            
                    
                     <cfif left(currLine, 3) eq "UNZ">
                        <cfset ix = ListGetAt(currLine,3,"+")>
                      </cfif>                 
                                                        
					<cfif left(currLine, 3) eq "OLD">
                        <!--- product EAN number --->
                        <cfset orderDetails[ListGetAt(currLine,2,"+")][1]=#ListGetAt(ListGetAt(currLine,3,"+"),1,":")#>	
                        <!--- description (not needed)--->
                  <!--- <cfset orderDetails[ListGetAt(currLine,2,"+")][2]=#ListGetAt(ListGetAt(currLine,3,"+"),3,":")#> --->
                        <!--- quantity ordered --->
                        <cfset orderDetails[ListGetAt(currLine,2,"+")][3]=#ListGetAt(ListGetAt(currLine,4,"+"),1,":")#>
                        <!--- unit cost --->	
                        <cfset orderDetails[ListGetAt(currLine,2,"+")][4]=#ListGetAt(ListGetAt(currLine,5,"+"),1,":")#>	
                        <!--- total cost --->
                        <cfset orderDetails[ListGetAt(currLine,2,"+")][5]=#ListGetAt(ListGetAt(currLine,6,"+"),1,":")#>
                        <!--- retail selling price --->	
                        <cfset orderDetails[ListGetAt(currLine,2,"+")][6]=#ListGetAt(ListGetAt(currLine,7,"+"),1,":")#>	
                    </cfif>               
                
                 </cfloop>
                 
      
                                            
				<cfset OrderContent.customerID = #customerID#>
                <cfset OrderContent.storeID = #storeID#>
                <cfset OrderContent.orderNumber = #orderNumber#>
                <cfset OrderContent.orderDate = #CreateDate(left(orderDate,2),mid(orderDate,3,2),right(orderdate,2))#>
                <cfset OrderContent.beforeDate = #CreateDate(left(beforeDate,2),mid(beforeDate,3,2),right(beforeDate,2))#>
                <cfset OrderContent.afterDate = #CreateDate(left(afterdate,2),mid(afterdate,3,2),right(afterdate,2))#>
                <cfset OrderContent.orderDetails = #orderDetails#>          
              <!---   <cfset OrderContent.ix = #ix#>           --->
 
       			<cfset Orders[#x#] = OrderContent>
                
            </cfloop>	                                 
                    

        




