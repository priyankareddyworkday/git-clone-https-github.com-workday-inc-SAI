select k.id
,k.casenumber as CaseNumber
,k.accountid
,k.contactid
,k.Status as Status
,k.Sub_Status as Sub_Status
,k.Case_Type as Case_Type
,k."Product Line" as "Product Line"
,k.Product as Product
,k.Subject as Subject
,k.SubProduct as SubProduct
,k.Area as Area
,k.Sub_Area as Sub_Area
,k."Product/Area" as "Product/Area"
,k."Sub-Product/Sub-Area" as "Sub-Product/Sub-Area"
,k.Closed_Reason as Closed_Reason
,k."case resolved by" as "case resolved by"
,k.Severity as Severity
,k.Initial_Severity as Initial_Severity
,k.Initial_Severity_Number as Initial_Severity_Number
, k.severity_number__c
,k.Jira_ID as Jira_ID
,k.Jira_Case_Exist as Jira_Case_Exist
,convert_timezone('UTC', 'US/Pacific', k.Dates) as Dates
,convert_timezone('UTC', 'US/Pacific', k."Case Created Date") as "Case Created Date"
,convert_timezone('UTC', 'US/Pacific', k."Case Closed Date") as "Case Closed Date"
,convert_timezone('UTC', 'US/Pacific', k."Case Escalated Date") as "Case Escalated Date"
,k.Assigned as Assigned
,k.Case_Owner_Manager as Case_Owner_Manager
,k.Analyst as Analyst
,k.Jira_status as Jira_Status
,k.Jira_Type as Jira_Type
,k. environment_type__c
,k.Isescalated as Isescalated 
,k.proactivetype as proactivetype
,k.Last_Comment as Last_Comment
,k."case owner manager" as "case owner manager"
,k."root cause" as "root cause"
,k.escalation_reason__c 
,k."Escalation Status" as "Escalation Status"
,contact.support_relationship__c as "NSC Support"
,contact.name as "NCS name"
,a.name as Account_Name
,a.PS_Region__c as PS_Region
,a.PS_Region_New__c as PS_Region_New
,a.technical_account_manager__c  AS "technical_account_manager__c"
,t."purpose_of_tenant__c" AS "purpose_of_tenant__c"
,t."data_center_name__c"
,t."status__c" AS "status__c"
,t."tenant_name__c" AS "tenant_name__c"
,CAST(t."tenant_type_name__c" AS TEXT) AS "tenant_type_name__c"
,u."name" 
,u.manager_name__c
,f.fiscal_date
,f.fiscal_year
,f.fiscal_year_name as "Fiscal Year Created"
,f.fiscal_year_month_name as "Fiscal Month Created"
,f.fiscal_quarter_name
,f.month_name
,f.fiscal_day_of_year as "day of year"
,f.fiscal_day_of_quarter as "day of quarter"
,f.fiscal_day_of_month as "day of month"
,f.fiscal_day_of_week as "day of week"
,dateadd( day,-1,current_date) as "Last updated"
from
(
select 
c.id as id
,c.casenumber as CaseNumber
,c.accountid as accountid
,c.contactid
,c.status as Status
,c.sub_status__c as Sub_Status
,c.case_type__c as Case_Type
,c.product_line__c as "Product Line"
,c.product__c as Product
,c.sub_product__c as SubProduct
,c.area__c as Area
,c.sub_area__c as Sub_Area
,case when (c.case_type__c='Production Support Request') then  c.product__c
     when (c.case_type__c='Customer Care Request') then  c.area__c
     when (c.case_type__c='Tenant Management Request') then  c.area__c
     else 'Not Applicable'
end as  "Product/Area"
,case when (c.case_type__c='Production Support Request') then  c.sub_product__c
     when (c.case_type__c='Customer Care Request') then  c.sub_area__c
     when (c.case_type__c='Tenant Management Request') then  c.sub_area__c
     else 'Not Applicable'
end as  "Sub-Product/Sub-Area"
,c.Closed_Reason__c as Closed_Reason
, c.case_resolved_by__c AS "case resolved by"
,c.Severity__c as Severity
,c.initial_case_severity__c as Initial_Severity
,c.initial_severity_number__c as Initial_Severity_Number
, c.severity_number__c
,c.jira_id__c as Jira_ID
,c.jira_case_exist__c as Jira_Case_Exist
,c.createddate as Dates
,c.createddate as "Case Created Date"
,c.closeddate as "Case Closed Date"
,NULL as "Case Escalated Date"
,c.owner_name__c as Assigned
,c.case_owner_manager__c as Case_Owner_Manager
,c.owner_name__c AS Analyst
,c.jira_status__c as Jira_Status
,c.jira_type__c as Jira_Type
,c.environment_type__c
,c.Isescalated
,            "left"(c.subject::text, 14) AS proactive_reactive, 
                    CASE
                        WHEN "left"(UPPER(c.subject::text),14) = 'PROACTIVE CASE'::character varying::text THEN 'Proactive'::character varying
                        ELSE 'Reactive'::character varying
                    END AS proactivetype
,   c.Last_Comment_Date_Time__c as Last_Comment
,  c.case_owner_manager__c AS "case owner manager"
,  c.root_cause__c AS "root cause"
,c.subject as Subject
,c.escalation_reason__c 
,NULL as "Escalation Status"
from bz_gsupport_data.src_sfdc_case c 
where convert_timezone('UTC', 'US/Pacific', c.createddate) > to_date('2021-01-31', 'yyyy-mm-dd') 

Union

select 
c.id as id
,c.casenumber as CaseNumber
,c.accountid as accountid
,c.contactid
,c.status as Status
,c.sub_status__c as Sub_Status
,c.case_type__c as Case_Type
,c.product_line__c as "Product Line"
,c.product__c as Product
,c.sub_product__c as SubProduct
,c.area__c as Area
,c.sub_area__c as Sub_Area
,case when (c.case_type__c='Production Support Request') then  c.product__c
     when (c.case_type__c='Customer Care Request') then  c.area__c
     when (c.case_type__c='Tenant Management Request') then  c.area__c
     else 'Not Applicable'
end as  "Product/Area"
,case when (c.case_type__c='Production Support Request') then  c.sub_product__c
     when (c.case_type__c='Customer Care Request') then  c.sub_area__c
     when (c.case_type__c='Tenant Management Request') then  c.sub_area__c
     else 'Not Applicable'
end as  "Sub-Product/Sub-Area"
,c.Closed_Reason__c as Closed_Reason
, c.case_resolved_by__c AS "case resolved by"
,c.Severity__c as Severity
,c.initial_case_severity__c as Initial_Severity
,c.initial_severity_number__c as Initial_Severity_Number
, c.severity_number__c
,c.jira_id__c as Jira_ID
,c.jira_case_exist__c as Jira_Case_Exist
,c.closeddate as Dates
,c.createddate as "Case Created Date"
,c.closeddate as "Case Closed Date"
,NULL as "Case Escalated Date"
,c.owner_name__c as Assigned
,c.case_owner_manager__c as Case_Owner_Manager
,c.owner_name__c AS Analyst
,c.jira_status__c as Jira_Status
,c.jira_type__c as Jira_Type
,c.environment_type__c
,c.Isescalated
,            "left"(c.subject::text, 14) AS proactive_reactive, 
                    CASE
                        WHEN "left"(UPPER(c.subject::text),14) = 'PROACTIVE CASE'::character varying::text THEN 'Proactive'::character varying
                        ELSE 'Reactive'::character varying
                    END AS proactivetype
,   c.Last_Comment_Date_Time__c as Last_Comment
,  c.case_owner_manager__c AS "case owner manager"
,  c.root_cause__c AS "root cause"
,c.subject as Subject
,c.escalation_reason__c 
,NULL as "Escalation Status"
from bz_gsupport_data.src_sfdc_case c 
where convert_timezone('UTC', 'US/Pacific', c.closeddate ) > to_date('2021-01-31', 'yyyy-mm-dd') 

union

select 
c.id as id
,c.casenumber as CaseNumber
,c.accountid as accountid
,c.contactid
,c.status as Status
,c.sub_status__c as Sub_Status
,c.case_type__c as Case_Type
,c.product_line__c as "Product Line"
,c.product__c as Product
,c.sub_product__c as SubProduct
,c.area__c as Area
,c.sub_area__c as Sub_Area
,case when (c.case_type__c='Production Support Request') then  c.product__c
     when (c.case_type__c='Customer Care Request') then  c.area__c
     when (c.case_type__c='Tenant Management Request') then  c.area__c
     else 'Not Applicable'
end as  "Product/Area"
,case when (c.case_type__c='Production Support Request') then  c.sub_product__c
     when (c.case_type__c='Customer Care Request') then  c.sub_area__c
     when (c.case_type__c='Tenant Management Request') then  c.sub_area__c
     else 'Not Applicable'
end as  "Sub-Product/Sub-Area"
,c.Closed_Reason__c as Closed_Reason
, c.case_resolved_by__c AS "case resolved by"
,c.Severity__c as Severity
,c.initial_case_severity__c as Initial_Severity
,c.initial_severity_number__c as Initial_Severity_Number
, c.severity_number__c
,c.jira_id__c as Jira_ID
,c.jira_case_exist__c as Jira_Case_Exist
,m.escalation_datetime as Dates
,c.createddate as "Case Created Date"
,c.closeddate as "Case Closed Date"
,m.escalation_datetime as "Case Escalated Date"
,c.owner_name__c as Assigned
,c.case_owner_manager__c as Case_Owner_Manager
,c.owner_name__c AS Analyst
,c.jira_status__c as Jira_Status
,c.jira_type__c as Jira_Type
,c.environment_type__c
,c.Isescalated
,            "left"(c.subject::text, 14) AS proactive_reactive, 
                    CASE
                        WHEN "left"(UPPER(c.subject::text),14) = 'PROACTIVE CASE'::character varying::text THEN 'Proactive'::character varying
                        ELSE 'Reactive'::character varying
                    END AS proactivetype
,   c.Last_Comment_Date_Time__c as Last_Comment
,  c.case_owner_manager__c AS "case owner manager"
,  c.root_cause__c AS "root cause"
,c.subject as Subject
,c.escalation_reason__c 
, m.escalationstatus as "Escalation Status"
from bz_gsupport_data.src_sfdc_case c 
left join bz_gsupport_data.bv_escalation_detail m on c.id = m.id 
where convert_timezone('UTC', 'US/Pacific', m.escalation_datetime) > to_date('2021-01-31', 'yyyy-mm-dd')
) k
left join bz_gsupport_data.src_sfdc_account a on k.accountid=a.id
left join bz_gsupport_data.src_sfdc_wta_customer_tenant__c t on t.Account__C=a.id
inner join bz_gsupport_data.src_sfdc_user u on a.technical_account_manager__c =u.id 
LEFT JOIN bz_gsupport_data.src_sfdc_contact contact ON k.contactid = contact.id
left join bz_gsupport_data.bv_fy_dates f on trunc(convert_timezone('UTC', 'US/Pacific', k.Dates)) = f.fiscal_date 
where f.fiscal_date Between to_date('2021-01-31', 'yyyy-mm-dd') 
 and sysdate
