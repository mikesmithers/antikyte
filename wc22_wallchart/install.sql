-- Installation script for the database components of this application
spool install.log 

prompt Creating Tables in the current schema
prompt =====================================

prompt MATCH_EVENT_TYPES

@tables/match_event_types.sql 

prompt STAGES

@tables/stages.sql 

prompt GROUP_POSITION_OVERRIDE

@tables/group_position_override.sql 

prompt DRAW

@tables/draw.sql 

prompt GROUPS

@tables/groups.sql 

prompt TEAMS
@tables/teams.sql 

prompt FIXTURES
@tables/fixtures.sql 

prompt MATCH_EVENTS
@tables/match_events.sql 

prompt Adding FKs for the circular TEAMS/DRAWS dependencies
@tables/teams_and_draw_fks.sql 

prompt Creating other Database Objects
prompt ===============================

prompt creating View GROUP_STANDINGS_VW 

@views/group_standings_vw.sql 

prompt creating Package MAINTAIN_DRAW

@packages/maintain_draw.pks
@packages/maintain_draw.pkb 

prompt creating trigger on FIXTURES
@trigger/fixtures_auc_trg.sql 

prompt Adding reference data
prompt =====================

prompt MATCH_EVENT_TYPES
@dml/pop_match_event_types.sql 

prompt STAGES
@dml/pop_stages.sql 

prompt GROUPS
@dml/pop_groups.sql 

prompt DRAW
@dml/pop_draw.sql


prompt TEAMS
@dml/pop_teams.sql 

prompt Adding teams to draw
@dml/add_teams_to_draw.sql 

prompt GROUP_POSITION_OVERRIDES
@dml/pop_group_position_overrides.sql 

prompt FIXTURES
@dml/add_group_fixtures.sql 
@dml/add_knockout_fixtures.sql 

spool off 