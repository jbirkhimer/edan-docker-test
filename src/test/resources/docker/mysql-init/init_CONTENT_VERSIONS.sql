create table if not exists edan_prod.CONTENT_VERSIONS
(
    id        varchar(36)                         not null,
    linked_id varchar(36)                         not null,
    content   longtext                            not null,
    timestamp timestamp default CURRENT_TIMESTAMP not null,
    constraint id_UNIQUE
        unique (id)
)
    collate = utf8_bin;

alter table edan_prod.CONTENT_VERSIONS
    add primary key (id);

INSERT INTO edan_prod.CONTENT_VERSIONS (id, linked_id, content, timestamp) VALUES ('d2a-1506699367361-1506700171050-0', 'd2a-1506699367361-1506700171048-0', '{"appId":"OCIODEV","content":{"test":"ok NEW-updated"},"linkedId":"","status":1,"title":"","type":"ocio-dev-test","unitCode":"OCIODEV","url":"new-record-for-me-1506700171188","publicSearch":true}', '2017-09-29 11:49:31');