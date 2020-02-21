create table if not exists edan_prod.CONTENT_CONFIG
(
    app_id                  varchar(50)  default 'EDAN'                not null,
    type                    varchar(45)  default 'config'              not null,
    content                 longtext                                   null,
    linked_id               varchar(36)                                not null,
    url                     varchar(255)                               not null,
    hash                    varchar(255) default ''                    not null,
    id                      varchar(36)                                not null,
    timestamp               timestamp    default CURRENT_TIMESTAMP     not null,
    last_time_updated       timestamp    default '0000-00-00 00:00:00' not null,
    loader_id               varchar(36)                                null,
    extension               longtext                                   null,
    status                  int(10)      default 0                     not null,
    public_search           tinyint(1)   default 1                     null,
    doc_signature           varchar(300) default ''                    null,
    version                 varchar(36)  default ''                    null,
    unit_code               varchar(36)  default 'EDAN'                not null,
    title                   varchar(255) default ''                    null,
    last_time_updated_epoch int(10)      default 0                     null,
    timestamp_epoch         int(10)      default 0                     null,
    primary key (app_id, type, linked_id, url),
    constraint uuid_UNIQUE
        unique (id)
)
    collate = utf8_bin;

create index if not exists idx_CONTENT_OBJECTS_app_id_type_url
    on edan_prod.CONTENT_CONFIG (app_id, type, url);

create index if not exists idx_CONTENT_OBJECTS_app_id_type_url_status
    on edan_prod.CONTENT_CONFIG (app_id, type, url, status);

create index if not exists last_time_updates
    on edan_prod.CONTENT_CONFIG (last_time_updated);

INSERT INTO edan_prod.CONTENT_CONFIG (app_id, type, content, linked_id, url, hash, id, timestamp, last_time_updated, loader_id, extension, status, public_search, doc_signature, version, unit_code, title, last_time_updated_epoch, timestamp_epoch) VALUES ('EDAN_CM', '', '{"publicSearch":true,"applicationId":"OCIO_ML","name":"OCIO_ML","unitCode":"OCIO","status":0,"secretKey":"7067a3bd1cc47a3c9404f21082eca90d7381519a","description":"application id for SI OCIO Machine Learning","contact":"Beth Stern"}', '', 'OCIO_ML', 'bb9df9a97438a3ac03d2599075d5142df3274cf1', 'adm-1510065287938-1510065287951-0', '2017-11-07 09:34:49', '2017-11-07 09:34:49', null, null, 0, 1, 'OCIO_ML_aa6b4e7ab6cdf1f8d450446e89406c97', 'adm-1510065287938-1510065287951-0', '', 'machine learning', 0, 0);