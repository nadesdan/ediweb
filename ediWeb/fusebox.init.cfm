<!---
	fusebox.init.cfm is included by the framework at the start of every request.
	It is included within a cfsilent tag so it cannot generate output. It is
	intended to be for per-request initialization and manipulation of the
	Fusebox fuseaction variables.
	
	You can set attributes.fuseaction, for example, to override the default
	fuseaction.
	
	A typical usage is to set "self" and "myself" variables, as shown below,
	for use inside display fuses when creating links.
--->
<cfset self = "index.cfm">
<cfset myself = "#self#?#application.fusebox.fuseactionVariable#=">

<cfset application.dsn = "edi"/>

<cfset application.filePath = "C:\Inetpub\wwwroot\ediWeb\edi-files\"/>

<cfset application.emailto = "danielb@sbacher.co.za"/>
<cfset application.emailcc = "justins@sbacher.co.za;anitas@sbacher.co.za;johanp@sbacher.co.za;grant@sbacher.co.za;candih@sbacher.co.za"/>

<cfif structKeyExists(URL,"reload")>
	<cfset structDelete(application,"ediParse") />
	<cfset structDelete(application,"ediImport") />
	<cfset structDelete(application,"ediMap") />
	<cfset structDelete(application,"fileActions") />
	<cfset structDelete(application,"createCsv") />
	<cfset structDelete(application,"ediQuery") />	
	<cfset structDelete(application,"ediFlat") />	
    <cfset structDelete(application,"email") />	
</cfif>

<cfif not structKeyExists(application,"ediParse")>
	<cflock name="#application.applicationName#_ediParse" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"ediParse")>
			<cfset application.ediParse = createObject("component","ediWeb.model.ediParse").init() />
		</cfif>
	</cflock>
</cfif>
<cfif not structKeyExists(application,"ediImport")>
	<cflock name="#application.applicationName#_ediImport" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"ediImport")>
			<cfset application.ediImport = createObject("component","ediWeb.model.ediImport").init(application.dsn) />
		</cfif>
	</cflock>
</cfif>
<cfif not structKeyExists(application,"ediMap")>
	<cflock name="#application.applicationName#_ediMap" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"ediMap")>
			<cfset application.ediMap = createObject("component","ediWeb.model.ediMap").init(application.dsn) />
		</cfif>
	</cflock>
</cfif>
<cfif not structKeyExists(application,"fileActions")>
	<cflock name="#application.applicationName#_fileActions" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"fileActions")>
			<cfset application.fileActions = createObject("component","ediWeb.model.fileActions").init(application.filePath) />
		</cfif>
	</cflock>
</cfif>
<cfif not structKeyExists(application,"createCsv")>
	<cflock name="#application.applicationName#_createCsv" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"createCsv")>
			<cfset application.createCsv = createObject("component","ediWeb.model.createCsv").init(application.dsn) />
		</cfif>
	</cflock>
</cfif>
<cfif not structKeyExists(application,"ediQuery")>
	<cflock name="#application.applicationName#_ediQuery" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"ediQuery")>
			<cfset application.ediQuery = createObject("component","ediWeb.model.ediQuery").init(application.dsn) />
		</cfif>
	</cflock>
</cfif>
<cfif not structKeyExists(application,"ediFlat")>
	<cflock name="#application.applicationName#_ediFlat" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"ediFlat")>
			<cfset application.ediFlat = createObject("component","ediWeb.model.ediFlat").init(application.dsn) />
		</cfif>
	</cflock>
</cfif>
<cfif not structKeyExists(application,"email")>
	<cflock name="#application.applicationName#_email" type="exclusive" timeout="10">
		<cfif not structKeyExists(application,"email")>
			<cfset application.email = createObject("component","ediWeb.model.email").init(application.dsn) />
		</cfif>
	</cflock>
</cfif>