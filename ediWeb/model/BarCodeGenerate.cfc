<cfcomponent displayname="BarCodeGenerate" hint="this componenet formats a barcode number so that it can be used with a barcode font">
	<cffunction name="createBarcode" access="public" returntype="string">
	
		<cfargument name="barCodeNumber" type="string" required="yes" default="" 
		hint="this is the actual barcode number">
		<cfargument name="barCodeType" type="string" required="yes" default="EAN13" 
		hint="this is the barcode type to be used">
		
		
		<cfobject type="com" name="barcode" 
			class="CRUFLidautomation.FontEncoder" server="WEB" 
			action="create" context="inproc">
		
		<cflock timeout="10" throwontimeout="no" type="exclusive">
			<cfif arguments.barCodeType eq "EAN13">
				<cfset barCodeResult = barcode.EAN13(#arguments.barCodeNumber#)>
			<cfelseif arguments.barCodeType eq "UPCa">
				<cfset barCodeResult = barcode.UPCa(#arguments.barCodeNumber#)>
			<cfelse>
				<cfset barCodeResult = "Invalid Barcode Type">	
			</cfif>
		</cflock>
		
		<cfreturn barCodeResult>
	</cffunction>
</cfcomponent>


