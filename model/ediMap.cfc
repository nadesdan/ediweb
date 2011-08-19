<cfcomponent name="ediMap">

	<cffunction name="init" access="public" returntype="ediMap" output="false" hint="Constructor.">	
		<cfargument name="dsn" type="string" required="yes"/>	
		<cfset variables.dsn = arguments.dsn>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="map" access="public" returntype="string">
	
		<cfquery name="ediMapHeader" datasource="#variables.dsn#">		
			update h
			set h.storeCode = c.IDCUST, h.storeName = c.NAMECUST, h.vatStatus = c.TAXSTTS1, status = 1
			from SBADAT.dbo.ARCUS c
			inner join SBADAT.dbo.ARCUSO_EAN e on c.IDCUST = e.IDCUST
			inner join ediHeader h on e.VALUE = h.storeEAN
			where h.status is null or h.status = 0 
		</cfquery>
	
		<cfquery name="ediMapHold" datasource="#variables.dsn#">		
			update ediHeader
			set status = 0
			where status is null 
		</cfquery>
	
		<cfquery name="ediMapDetails" datasource="#variables.dsn#">		
			update d
			set d.itemNo = i.ITEMNO, d.itemDesc = i."DESC"
			from SBADAT.dbo.ICITEM i
			inner join SBADAT.dbo.ICIOTH h on i.ITEMNO = h.ITEMNO
			inner join ediDetail d on right(RTRIM(CAST(MANITEMNO as char(13))),12) = right(d.productEAN,12)
			where d.itemno is null 
		</cfquery>
	
	</cffunction>
	
</cfcomponent>	