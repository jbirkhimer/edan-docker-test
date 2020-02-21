create table if not exists edan_prod.CONTENT_REPO
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
    on edan_prod.CONTENT_REPO (app_id, type, loader_id);

create index if not exists deltas
    on edan_prod.CONTENT_REPO (last_time_updated);

create index if not exists linked_id
    on edan_prod.CONTENT_REPO (linked_id);

create index if not exists loader_id
    on edan_prod.CONTENT_REPO (loader_id);

create index if not exists type
    on edan_prod.CONTENT_REPO (type, url);

alter table edan_prod.CONTENT_REPO
    add primary key (id);

INSERT INTO edan_prod.CONTENT_REPO (app_id, type, content, linked_id, url, hash, id, timestamp, status, doc_signature, version, unit_code, public_search, title, last_time_updated, loader_id, extension) VALUES ('OCIO3D', 'edanmdm', '{"descriptiveNonRepeating":{"title":{"label":"Title","content":"Sir Ferdinando Wainman burial"},"data_source":"Smithsonian Institution, Digitization Program Office","unit_code":"DPO","record_ID":"dpo_3d_200001","metadata_usage":{"access":"Usage conditions apply"}},"indexedStructured":{"object_type":["Burial"]},"freetext":{"identifier":[{"label":"Field Identifier","content":"Jamestown Chancel Burial B 2992C"}],"name":[{"label":"Collector","content":"Jamestown Rediscovery (Preservation Virginia)"}],"dataSource":[{"label":"Data Source","content":"Smithsonian Institution, Digitization Program Office"}],"objectRights":[{"label":"Credit Line","content":"The Jamestown Chancel Burial investigation is a collaboration between the Smithsonian''s Skeletal Biology Program, the Smithsonian 3D Digitization Program Office and Jamestown Rediscovery."}],"objectType":[{"label":"Object Type","content":"Burial"}],"notes":[{"label":"Summary","content":"Sir Ferdinando Wainman, Master of the Ordnance (artillery and fortifications) at James Fort and an investor in the Virginia Company, was a knight who served in a high military position, being responsible for Jamestown''s arms and armor. Wainman—born in 1576 in Oxfordshire, England, to an aristocratic family—was the first cousin of Thomas West, Lord De La Warr, the first governor of Virginia. Wainman arrived at James Fort with Lord De La Warr on June 10, 1610. Not long after their arrival, Wainman was appointed to his position as Master of the Ordnance, was placed in charge of the colony’s horse troops, and was named to the governing council. However, little is known about his time in Virginia.\\r\\n\\r\\n \\r\\nWainman died in 1610 a few months after his arrival at James Fort at the age of about 35 years. Genealogical records indicate that Wainman was the first English knight buried in America. Given his status and relationship to Lord De La Warr, he would have been buried in the chancel of the fort’s church with the highest honors. Wainman’s death in the same year as another of De La Warr’s kinsman – Captain William West – may explain the similarities in their two coffins. Built in the same elaborate fashion, the materials for these coffins and perhaps their carpenter, would have recently arrived on the 1610 resupply ship carrying Lord De La Warr, William West, and Sir Ferdinando Wainman. "}],"place":[{"label":"Site Name","content":"Historic Jamestowne"}],"date":[{"label":"Collection Date","content":"Historic Jamestowne"}],"taxonomicName":[{"label":"Taxonony","content":"Homo sapiens"}]}}', '', 'edanmdm:dpo_3d_200001', '4d2c7476ca2183cd8e7fbb366b5680d2b3207379', '123-1580492962881-1580492966288-0', '2020-01-31 12:49:24', 0, '83140ff52f2661a88658f7938e9ac175', '123-1580492962881-1580492966288-0', 'SI', 1, 'Sir Ferdinando Wainman burial', '2020-01-31 22:23:12', null, '');