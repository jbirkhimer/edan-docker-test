create table if not exists edan_prod.CONTENT_OBJECTS
(
    mysql_id                int(11) unsigned auto_increment,
    app_id                  varchar(50)  default 'EDAN'            not null,
    type                    varchar(45)  default 'objectgroup'     not null,
    content                 longtext                               null,
    linked_id               varchar(36)                            not null,
    url                     varchar(255)                           not null,
    hash                    varchar(255) default ''                not null,
    id                      varchar(36)                            not null,
    timestamp               timestamp    default CURRENT_TIMESTAMP not null,
    status                  int(10)      default 0                 not null,
    doc_signature           varchar(255)                           null,
    version                 varchar(255)                           null,
    unit_code               varchar(45)  default 'EDAN'            not null,
    public_search           tinyint(1)   default 1                 null,
    title                   varchar(425) default ''                null,
    last_time_updated_epoch int(10)      default 0                 null,
    timestamp_epoch         int(10)      default 0                 null,
    last_time_updated       timestamp                              null,
    loader_id               varchar(36)                            null,
    extension               longtext                               null,
    primary key (unit_code, type, linked_id, url),
    constraint hash_UNIQUE
        unique (hash),
    constraint id_UNIQUE
        unique (mysql_id),
    constraint uuid_UNIQUE
        unique (id)
)
    collate = utf8_bin;

create index if not exists appid
    on edan_prod.CONTENT_OBJECTS (app_id);

create index if not exists deltas
    on edan_prod.CONTENT_OBJECTS (last_time_updated);

create index if not exists doc_sig
    on edan_prod.CONTENT_OBJECTS (doc_signature, status);

create index if not exists type
    on edan_prod.CONTENT_OBJECTS (type);

INSERT INTO edan_prod.CONTENT_OBJECTS (mysql_id, app_id, type, content, linked_id, url, hash, id, timestamp, status, doc_signature, version, unit_code, public_search, title, last_time_updated_epoch, timestamp_epoch, last_time_updated, loader_id, extension) VALUES (82543, 'AAA', 'objectgroup', '{"menu":["p1a-1553948739452-1554752661146-0","p1a-1469529601706-1470346092010-0","p1a-1469529601706-1470332591997-0","p1a-1469529601706-1470332629073-0","p1a-1469529601706-1470332683307-0","p1a-1469529601706-1470332708296-0"],"page":{},"feature":{"type":"image","url":"https://www.aaa.si.edu/sites/default/files/ogmt_admin/image_upload/armory-show-graphic_0.jpg","alt":"Armory Show Graphic","html":""},"settings":{},"defaultPageId":"p1a-1553948739452-1554752661146-0","title":"1913 Armory Show: The Story in Primary Sources","listTitle":"1913 Armory Show","description":"The Smithsonian\\u0027s Archives of American Art commemorates the centennial of the International Exhibition of Modern Art, known as the 1913 Armory Show--the first major exhibition of European modern art in the U.S.","keywords":"armory show, picasso, walt kuhn","featured":0,"groupType":0,"published":0}', '', '1913-armory-show', '6e6f851c29112900cbbd250e1410ca981ecfbccf', 'p1a-1469529601706-1470332475765-0', '2016-08-04 13:41:15', 0, '24ebdd71b30966f7156a1bf126a8bdc0', 'p1a-1469529601706-1470332475765-0', 'AAA', 1, '1913 Armory Show: The Story in Primary Sources', 0, 0, '2019-11-14 12:17:37', '1470332475', null);