create table if not exists edan_prod.CONTENT_OBJECTS_AWS
(
    app_id            varchar(50)  default 'edan'            not null,
    type              varchar(45)  default 'edan'            not null,
    content           longtext                               not null,
    linked_id         varchar(36)                            not null,
    url               varchar(255)                           not null,
    hash              varchar(255) default ''                not null,
    id                varchar(36)                            not null,
    timestamp         timestamp    default CURRENT_TIMESTAMP not null,
    status            int(10)      default 0                 not null,
    doc_signature     varchar(255)                           null,
    version           varchar(255)                           null,
    unit_code         varchar(45)  default 'edan'            null,
    public_search     tinyint(1)   default 1                 null,
    title             varchar(425) default ''                null,
    last_time_updated timestamp                              null,
    loader_id         varchar(36)                            null,
    extension         longtext                               not null,
    constraint hash_UNIQUE
        unique (hash),
    constraint url_UNIQUE
        unique (url),
    constraint uuid_UNIQUE
        unique (id)
)
    collate = utf8_bin;

create index if not exists bulk_delta
    on edan_prod.CONTENT_OBJECTS_AWS (app_id, type, loader_id);

create index if not exists deltas
    on edan_prod.CONTENT_OBJECTS_AWS (last_time_updated);

create index if not exists linked_id
    on edan_prod.CONTENT_OBJECTS_AWS (linked_id);

create index if not exists loader_id
    on edan_prod.CONTENT_OBJECTS_AWS (loader_id);

create index if not exists type
    on edan_prod.CONTENT_OBJECTS_AWS (type, url);

alter table edan_prod.CONTENT_OBJECTS_AWS
    add primary key (id);

INSERT INTO edan_prod.CONTENT_OBJECTS_AWS (app_id, type, content, linked_id, url, hash, id, timestamp, status, doc_signature, version, unit_code, public_search, title, last_time_updated, loader_id, extension) VALUES ('AWS', 'AWSFILE', '{"logs":[{"success":true,"auditline":"AWS PASS","date":"1579008204271","filename":"/dropbox/awsdrop/NASM_2020-01-13_18232932/NASM-98-16042.tif","awsfile":"NASM-98-16042.tif"}],"uan":"NASM-98-16042","file":"NASM-98-16042.tif","aws_url":"https://smithsonian-open-access.s3-us-west-2.amazonaws.com/media/nasm/NASM-98-16042.tif"}', '', 'file:NASM-98-16042.tif', '0338b480bdb19fbe453e1cddd17324725e4833bb', 'aws-1580246742333-1580246743594-0', '2020-01-28 16:25:46', 1, '022cc8a13f9873d9e4c9cf8ee0d2cbb7', '', '', 0, 'NASM-98-16042', '2020-01-28 16:25:46', null, '');