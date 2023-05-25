--create or replace view adempiere.rpt_asset_v
--AS
--select a.ad_client_id , a.ad_org_id, a.a_asset_id ,
--a.value , a."name" as asset , a.inventoryno, a.a_asset_group_id,
--a.a_asset_createdate , a.a_asset_status, ag.name as asset_group, ag.isowned,
--agc.a_depreciation_id, agc.uselifeyears, agc.uselifemonths,
--dw.a_asset_cost, dw.a_accumulated_depr, dw.a_asset_remaining,
--(case when dw.UseLifeMonths -
--(case when A_Current_Period = 0 then 1 else A_Current_Period end )+ 1> 0 then
--(A_Asset_Cost - A_Accumulated_Depr)/(dw.UseLifeMonths - (case when A_Current_period = 0
--then 1 else A_Current_Period end) + 1) else 0 end)
--from A_Asset a
--join a_asset_group ag on a.a_asset_group_id = ag.a_asset_group_id
--join a_asset_group_acct agc on ag.a_asset_group_id = agc.a_asset_group_id 
--join a_depreciation_workfile dw on a.a_asset_id = dw.a_asset_id
--where a.a_asset_id =1000004
--alter table adempiere.rpt_asset_av owner to adempiere;

create or replace view adempiere.rpt_asset_a AS
select a.ad_client_id, a.ad_org_id, a.a_asset_id, a.a_asset_group_id, a.value, dw.a_asset_remaining_f from a_asset a
join A_Asset_Group AG on a.a_asset_group_id = AG.a_asset_group_id
join A_Depreciation_Workfile dw on a.a_asset_id = dw.a_asset_id
where a.a_asset_group_id = 1000010 or a.a_asset_group_id = 1000015
or a.A_Asset_Group_ID=1000008 or a.A_Asset_Group_ID=1000012 or a.A_Asset_Group_ID=1000009 order by a.value;
alter table adempiere.rpt_asset_a owner to adempiere;

create or replace view adempiere.rpt_asset_b AS
with cte
as
(select a.ad_client_id, a.ad_org_id, a.a_asset_id, a.a_asset_group_id, a.value, dw.a_asset_remaining_f from a_asset a
join A_Asset_Group AG on a.a_asset_group_id = AG.a_asset_group_id
join A_Depreciation_Workfile dw on a.a_asset_id = dw.a_asset_id
where a.a_asset_group_id = 1000010 or a.a_asset_group_id = 1000015
or a.A_Asset_Group_ID=1000008 or a.A_Asset_Group_ID=1000012 or a.A_Asset_Group_ID=1000009 order by a.value
)

select * from cte;
alter table adempiere.rpt_asset_b owner to adempiere;

with cte as
(
select a.ad_client_id, a.ad_org_id, AG."name", SUM(dw.a_asset_remaining_f) as amount from a_asset a
join A_Asset_Group AG on a.a_asset_group_id = AG.a_asset_group_id
join A_Depreciation_Workfile dw on a.a_asset_id = dw.a_asset_id
where a.a_asset_group_id = 1000010 or a.a_asset_group_id = 1000015
or a.A_Asset_Group_ID=1000018 or a.A_Asset_Group_ID=1000012 or a.A_Asset_Group_ID=1000009
group by AG.a_asset_group_id, a.ad_client_id, a.ad_org_id
)

select * from cte;