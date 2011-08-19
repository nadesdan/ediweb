<cfcomponent output="false">

	<cffunction name="init" access="public" returntype="fileActions" output="false" hint="Constructor.">
			<cfargument name="path" type="string" required="yes">
			<cfset variables.path = arguments.path />
			<cfreturn this />
	</cffunction>	

	<cffunction name="readFile" access="public" returntype="string">
	
		<cfargument name="filename" type="string" required="yes">
		
		<cfset var fileContent = "no"> 
		
		<cfif FileExists("#variables.path##arguments.filename#") is "Yes"> 
			<cffile action="read" file="#variables.path##arguments.filename#" variable="fileContent">
		</cfif> 
		
		<cfreturn fileContent>
				
		
	</cffunction>



	<cffunction name="writeFile" access="public" returntype="string">
	
		<cfargument name="filename" type="string" required="yes">
		<cfargument name="content" type="string" required="yes">
				
		<cfset var outputContent = "#ReplaceNoCase(arguments.content, "#Chr(13)##Chr(13)#", "#Chr(13)#", "ALL")#"/>
		
		<cfif arguments.content neq "">
		<cfif FileExists("#variables.path##arguments.filename#") is "Yes"> 	
			<cffile action="append" addnewline="yes" file="#variables.path##arguments.filename#" output="#outputContent#" fixnewline="no">
		<cfelse>	
			<cffile action="WRITE" addnewline="No" file="#variables.path##arguments.filename#" output="#outputContent#">
		</cfif>	
		</cfif>
		
		<cfreturn outputContent>
		
	</cffunction>
	
	
	<cffunction name="deleteFile" access="public" returntype="string">
	
		<cfargument name="filename" type="string" required="yes">
		<cfset var fileDelete = "">
		
		<cfif FileExists("#variables.path##arguments.filename#") is "Yes"> 				
			<cffile action="delete" file="#variables.path##arguments.filename#">
			<cfset fileDelete = insert(variables.path,arguments.filename,0)>
		<cfelse>
			<cfset fileDelete = "no">
		</cfif>		
		
		<cfreturn fileDelete>
				
	</cffunction>
		
	<cffunction name="renameFile" access="public" returntype="string">
	
		<cfargument name="filename" type="string" required="yes">
        <cfargument name="newfile" type="string" required="yes">
		<cfset var fileRename = "">
		
		<cfif FileExists("#variables.path##arguments.filename#") is "Yes"> 				
			<cffile action="rename"
             destination="#variables.path##arguments.newfile#"
             source="#variables.path##arguments.filename#">
			<cfset fileRename = insert(variables.path,arguments.filename,0)>
		<cfelse>
			<cfset fileRename = "no">
		</cfif>		
		
		<cfreturn fileRename>
				
	</cffunction>	
	
</cfcomponent>