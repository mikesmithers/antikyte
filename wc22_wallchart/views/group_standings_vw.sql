create or replace view group_standings_vw
as
    with 
        group_games as (
            select 
                t1_cid as t_cid, 
                group_cid,
                count(t1_cid) as P,
                sum( case t1_pts when 3 then 1 else 0 end) as W,
                sum( case t1_pts when 1 then 1 else 0 end) as D,
                sum( case t1_pts when 0 then 1 else 0 end) as L,
                sum( t1_score) as F,
                sum( t2_score) as A,
                sum( t1_pts) as Pts
            from fixtures
            where t1_score is not null
            and stage_cid = 'GROUP'
            group by t1_cid, group_cid
            union
            select 
                t2_cid, 
                group_cid,
                count(t2_cid) as P,
                sum( case t2_pts when 3 then 1 else 0 end) as W,
                sum( case t2_pts when 1 then 1 else 0 end) as D,
                sum( case t2_pts when 0 then 1 else 0 end) as L,
                sum( t2_score) as F,
                sum( t1_score) as A,
                sum( t2_pts) as Pts
            from fixtures
            where t2_score is not null
            and stage_cid = 'GROUP'
            group by t2_cid, group_cid),
        group_records as (    
            select 
                teams.cid,
                teams.group_cid,
                sum(nvl(gg.P,0)) as Pld,
                sum(nvl(gg.W,0)) as W,
                sum(nvl(gg.D,0)) as D,
                sum(nvl(gg.L,0)) as L,
                sum(nvl(gg.F,0)) as F,
                sum(nvl(gg.A,0)) as A,
                sum(nvl(gg.Pts,0)) as Pts,
                sum( nvl( gg.f, 0)) - sum( nvl(gg.a, 0)) as GD
             from teams
             left outer join group_games gg
                on gg.t_cid = teams.cid
             group by teams.cid, teams.group_cid),
        group_standings as (     
        select 
            cid, group_cid,
            gr.pld, gr.w, gr.d, gr.l, gr.f, gr.a, gr.pts, gr.gd,
            rank() over( partition by group_cid order by pts desc, gd desc, f desc) as pos
        from group_records gr)
    select st.cid, st.group_cid,
        pld, w, d, l, f, a, pts, gd, nvl(ov.final_position, pos) as pos
    from group_standings st
    inner join group_position_override ov
        on ov.group_cid = st.group_cid
        and ov.team_cid = st.cid
/

