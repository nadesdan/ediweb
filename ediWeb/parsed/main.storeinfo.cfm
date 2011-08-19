<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: main --->
<!--- fuseaction: storeinfo --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "main">
<cfset myFusebox.thisFuseaction = "storeinfo">
<cfset storeInfo = application.ediQuery.qryStoreSummary(#attributes.shortName#,#attributes.status#,#attributes.batchid#) >
<!--- do action="v.storeinfo" --->
<cfset myFusebox.thisCircuit = "v">
<cfsavecontent variable="pageContent">
<cfset xfa.viewOrders = "main.info" />
<cftry>
<cfoutput><cfinclude template="../views/dsp_storeinfo.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 17 and right(cfcatch.MissingFileName,17) is "dsp_storeinfo.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_storeinfo.cfm in circuit v which does not exist (from fuseaction v.storeInfo).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="main.menu" --->
<cfset myFusebox.thisPhase = "postprocessFuseactions">
<cfset myFusebox.thisCircuit = "main">
<cfset myFusebox.thisFuseaction = "menu">
<cfset batchInfo = application.ediQuery.qryBatch() >
<!--- do action="v.menu" --->
<cfset myFusebox.thisCircuit = "v">
<cfset xfa.createCSVFile = "main.createCSVFile" />
<cfset xfa.viewOrders = "main.info" />
<cfset xfa.viewComplete = "main.complete" />
<cfset xfa.export = "main.export" />
<cfset xfa.email = "main.email" />
<cftry>
<cfsavecontent variable="pageMenu"><cfoutput><cfinclude template="../views/dsp_menu.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "dsp_menu.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_menu.cfm in circuit v which does not exist (from fuseaction v.menu).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<!--- do action="layout.apply" --->
<cfset myFusebox.thisCircuit = "layout">
<cfset myFusebox.thisFuseaction = "apply">
<cftry>
<cfoutput><cfinclude template="../layout/dsp_layout.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 14 and right(cfcatch.MissingFileName,14) is "dsp_layout.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_layout.cfm in circuit layout which does not exist (from fuseaction layout.apply).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

