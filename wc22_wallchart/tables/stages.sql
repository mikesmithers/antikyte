create table stages(
    cid varchar2(25),
    stage_name varchar2(250) not null,
    constraint stages_pk primary key (cid))
/

comment on table stages is 'The stages that the tournement progresses through, culminating in the Final';
comment on column stages.cid is 'The Unique Identifier for this stage. Primary Key';
comment on column stages.stage_name is 'The text name of this stage';

alter table stages add stage_order number;

comment on column stages.stage_order is 'The sequence in which this stage takes place in the tournament';