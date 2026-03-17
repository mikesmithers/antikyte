create table hitchhikers
(
    id number generated always as identity,
    being_name varchar2(100),
    species varchar2(100),
    is_poet varchar2(1),
    notes varchar2(4000)
)
/

insert into hitchhikers( being_name, species, is_poet, notes)
values('Prostetnic Jeltz', 'VOGON', 'Y', q'[Author of the IT Policy you're currently grappling with]');

insert into hitchhikers( being_name, species, is_poet, notes)
values('Zaphod Beeblebrox', 'BETELGEUSIAN', 'N', 'Worst Dressed Sentient Being');

insert into hitchhikers( being_name, species, is_poet, notes)
values('Trillian', 'HUMAN', 'N', 'Mathematician and Astrophysicist');

insert into hitchhikers( being_name, species, is_poet, notes)
values('Grunthos the Flatulent', 'Asgoth of Kria', 'Y', 'A poet of Galactic renown' );

commit;