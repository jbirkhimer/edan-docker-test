create table if not exists edan_prod.CONTENT_PROPERTIES
(
    id        int(11) unsigned auto_increment,
    k         varchar(50)  not null,
    v         varchar(200) not null,
    linked_id varchar(50)  not null,
    primary key (k, linked_id, v),
    constraint id_UNIQUE
        unique (id)
)
    charset = utf8;

create index if not exists kv
    on edan_prod.CONTENT_PROPERTIES (v, linked_id);

create index if not exists kvl
    on edan_prod.CONTENT_PROPERTIES (k, v, linked_id);

create index if not exists linked_id
    on edan_prod.CONTENT_PROPERTIES (linked_id);

create index if not exists v
    on edan_prod.CONTENT_PROPERTIES (v);

INSERT INTO edan_prod.CONTENT_PROPERTIES (id, k, v, linked_id) VALUES (3437, 'p.listName', 'NPGOGMT:dpt-1437480002537-1445021131904-0:dpt-1445615484282-1445615949448-0', 'dpt-1446148802114-1446227825924-0');