<cfcomponent name="ediFlat" hint="this component creates an EDI flat file">

		<cffunction name="init" access="public" returntype="ediFlat" output="false" hint="Constructor.">		
		<cfargument name="dsn" type="string" required="yes" />		
			<cfset variables.dsn = arguments.dsn>		
			<cfreturn this />			
		</cffunction>	

<cffunction access="public" name="invoice" output="yes">
	
	
<cfsavecontent variable="invContent"><cftransaction>
<cfquery name="invflt" datasource="#variables.dsn#">SELECT h.INVUNIQ as orduniq,
RTRIM(h.INVNUMBER) as invoice,
h.PONUMBER as po,
LEFT(h.PONUMBER + SPACE(13),11) as ponumber,
RTRIM(h.CUSTOMER) as customer,
RTRIM(a.VALUE) as storeid,
RIGHT(h.INVDATE,6) as invdate,
RIGHT(h.ORDDATE,6) as orddate,
d.LINENUM/32 as linenum,
RTRIM(CAST(m.MANITEMNO as char(13))) as barcode,
RTRIM(i.ITEMNO) as item,
RTRIM(i."DESC") as itemdesc,
d.QTYSHIPPED as qty,
extcost = 
CASE 
WHEN d.TBASE1 > 0 THEN ROUND(d.TBASE1,2)
ELSE ROUND(0.01*QTYSHIPPED,2)
END,
unitcost = 
CASE 
WHEN d.TBASE1 > 0 THEN ROUND(d.TBASE1 / d.QTYSHIPPED,2)
ELSE ROUND(0.01,2)
END,
nettotal = 
CASE 
WHEN h.TBASE1 > 0 THEN ROUND(h.TBASE1,2)
ELSE ROUND(0.01*QTYSHIPPED,2)
END,
total = 
CASE 
WHEN h.TBASE1 > 0 THEN ROUND(h.INVNETWTX,2)
ELSE ROUND(0.01*QTYSHIPPED*(1+d.TRATE1),2)
END,
d.TRATE1 as vatrate,
ROUND(d.PRIBASPRC,2) as retail,
ROUND(h.INVETAXTOT + h.INVITAXTOT,2) as taxtotal
from SBADAT.dbo.OEINVH h
inner join SBADAT.dbo.ARCUS c on h.CUSTOMER = c.IDCUST
inner join SBADAT.dbo.OEINVD d on h.INVUNIQ = d.INVUNIQ
inner join SBADAT.dbo.ICITEM i on d.ITEM = i.FMTITEMNO
inner join SBADAT.dbo.ICIOTH m on i.ITEMNO = m.ITEMNO
inner join SBADAT.dbo.ARCUSO_EAN a on h.CUSTOMER = a.IDCUST
where h.PONUMBER IN (select distinct ordernumber from ediweb.DBO.ediheader where status = 4) and c.IDGRP in ('EDG','FOS')
and d.QTYSHIPPED <> 0
<!--- and h.INVNUMBER NOT IN (SELECT invnumber FROM SBADAT.dbo.oecrdh) --->
order by h.INVUNIQ</cfquery><cfoutput query="invflt" group="invoice"><cfif LEFT(invflt.customer,3) eq "EDG"><cfset supplierid = 6002782000012><cfset vatid = 4460236773><cfelseif LEFT(invflt.customer,1) eq "F"><cfset supplierid = '6002973002931'><cfset vatid = 4210187250></cfif>UNBT <!--- supplier id, control ref ---><cfset blank="                                          ">#supplierid# #blank# #invoice#
UNBA TAXINV
UNH  1
SAP  6006992000015 4220115952
SDP  6006992000015 S. BACHER & COMPANY (PTY) LTD
SDPA Alon House                          2 Hood Ave
SDPB Rosebank
CLO  <!--- store id, supplierid--->#storeid# <cfif LEFT(invflt.customer,3) eq "EDG">#storeid#<cfelseif LEFT(invflt.customer,3) eq "FOS">#supplierid#</cfif>
CLOC <!--- alternate store id, vat number--->#supplierid# #vatid#
IRE  <!--- invoice, invoice date---><cfset blank="   ">#invoice##RepeatString(" ",14-len(invoice))# #invdate#
ODD  <!--- line seq, customer po, order date---><cfset blank="                 ">0000 #ponumber##RepeatString(" ",14-len(ponumber))# #RepeatString(" ",14)# #orddate#
CNF  0001 1
<cfoutput>ILD  <!--- orderid, line, product barcode --->0001 #numberformat(linenum,"0000")# <cfif len(barcode) eq 12>00<cfelseif len(barcode) eq 13>0</cfif>#barcode#
ILDA <!--- product desc --->#item# #itemdesc#
ILDB <!--- qty --->#numberformat(qty,"0000000000.000")#
ILDC <!--- unit cost price --->#numberformat(unitcost,"00000000.0000")#
ILDH <!--- ext cost, vat rate, unit cost ---><cfset blank="  ">#numberformat(extcost,"00000000.0000")# #blank# #numberformat(vatrate,"000.0000")# S #numberformat(unitcost,"0000000.0000")#
ILDK <!--- retail ---><cfif retail neq 0>#numberformat(retail,"0000000.00")#<cfelse>#numberformat(0.01,"0000000.00")#</cfif>#chr(13)##chr(10)#</cfoutput>VRS  <!--- line seq, vat rate, no. of lines, total ex vat, total vat--->0001 #numberformat(vatrate,"000.0000")# S 001 #numberformat(nettotal,"00000000.0000")# #numberformat(taxtotal,"00000000.0000")#
IPD  <!--- total ex vat, total vat, inv total, 0,0 --->#numberformat(nettotal,"00000000.0000")# #numberformat(taxtotal,"00000000.0000")# #numberformat(total,"00000000.0000")# 0000001.000 00001
SDI  <!--- line seq, total inv, --->0001 #numberformat(total,"00000000.0000")# 000.0000 00000000.0000 000
UNHT 1
VRET <!--- line seq, vat rate, total ex vat, total vat, inv total--->0001 #numberformat(vatrate,"000.0000")# S #numberformat(nettotal,"00000000.0000")# #numberformat(taxtotal,"00000000.0000")# #numberformat(total,"00000000.0000")#
BTTT <!--- total ex vat, total vat, inv total--->#numberformat(nettotal,"00000000.0000")# #numberformat(taxtotal,"00000000.0000")# #numberformat(total,"00000000.0000")##chr(13)##chr(10)#</cfoutput>

<cfquery name="updateEdiInv" datasource="#variables.dsn#">update ediweb.DBO.ediheader 
set ediHeader.invoice = o.invnumber, ediHeader.status = 5, ediHeader.invoiceDate = o.invDate, exportDate = getdate()
FROM SBADAT.dbo.OEINVH o
where o.ponumber = ediHeader.ordernumber
and o.ponumber in (<cfloop query="invflt">'#po#',</cfloop>'0')
</cfquery>

</cftransaction></cfsavecontent>

<cfreturn invContent>

</cffunction>



<cffunction access="public" name="cancel">

<cfsavecontent variable="cnclContent"><cftransaction><cfquery name="cnclflt" datasource="#variables.dsn#">select orderid, customerEAN as customerid,
storeEAN as storeid,
orderDate as orderdate, 
orderNumber as ordernumber,
LEFT(orderNumber + SPACE(13),28) as ponumber
from ediHeader
where status = 7 and customerEAN = '6002782000012'
</cfquery><cfoutput query="cnclflt">UNB  <!--- customer id, control ref ---><cfset blank="                                          ">#customerid# #blank# C-#ordernumber#
UNBA ORDERS
UNBB 6006992000015
UNH  <!--- store id--->#ordernumber#
SOP  6006992000015
CLO  <!--- store id, store id--->#storeid# #storeid#
CLOC <!--- alternate store id, vat number--->#customerid#
ORD  #ponumber# #dateFormat(orderdate,"yymmdd")# U#chr(13)##chr(10)#</cfoutput>

<cfquery name="updateEdiCncl" datasource="#variables.dsn#">update ediHeader
set status = 6, exportDate = getdate()
where orderid in (<cfloop query="cnclflt">#orderid#,</cfloop>0)
</cfquery>
<cfquery name="updateEdiCnclFos" datasource="#variables.dsn#">update ediHeader
set status = 6, exportDate = getdate()
where customerEAN <> '6002782000012' and status = 7
</cfquery>
</cftransaction></cfsavecontent>

<cfreturn cnclContent>

</cffunction>


</cfcomponent>