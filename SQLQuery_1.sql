select * from PERSONATGES order by id;

select * from ENEMICS;

select * from ARMES;

select * from ATACS;

select * from SKINS;

/*
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (40,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (41,30, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (42,30, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (43,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (44,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (6,70, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (45,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (46,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (47,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (48,45, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (49,30, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (50,25, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (51,30, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (52,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (31,70, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (53,60, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (54,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (55,50, Null);
insert into ENEMICS(personatge_id,punts_donats, musica_combat) VALUES (56,50, Null); */

-- Categories: 1 estrella, 2 estrelles, 3 estrelles, 4 estrelles

/*
-- Aizen
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aizen Bo',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738748715/PERSONATGES/Aizen/vqulmklrsxme33zt2crk.png',1,1);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aizen Dolent Ulleres',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750831/ENEMICS/Aizen/u6xihhxt3zvaxqmhjbqo.png',1,1);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aizen Dolent Arrancar',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750833/ENEMICS/Aizen/jzh3wwccdfvzmdlgxy8z.png',1,1);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aizen Dolent Xetat',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750830/ENEMICS/Aizen/ir3c8h0q22fuvmvxjls0.png',1,1);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aizen Dolent Garganta',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750831/ENEMICS/Aizen/si6frlfn7ylwb2msmhro.png',1,1);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aizen Dolent Hogyoku',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750832/ENEMICS/Aizen/iqjkegmuz2dxkc3q0d0k.png',1,1);

-- Byakuya
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Byakuya',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739005954/PERSONATGES/Byakuya/n84j6b0teidzlg9wqjg5.png',2,2);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Byakuya Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739005953/PERSONATGES/Byakuya/xs0juulfty62xdhqzj5t.png',2,2);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Byakuya Senbonzakura',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739005954/PERSONATGES/Byakuya/zfqalutze6ozlerlxbkp.png',2,2);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Byakuya Bankai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739005954/PERSONATGES/Byakuya/iip9b9ywssi8nzshiehn.png',2,2);

-- Chad
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Chad',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738745390/PERSONATGES/Chad/zkpdncihgpxaanpkwo1w.png',3,3);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Chad Derecho',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738745420/PERSONATGES/Chad/umahiwkmkhftrwppfz5v.png',3,3);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Chad Derecho Gigante',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738745467/PERSONATGES/Chad/ids78p74vaagawpk1xol.png',3,3);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Chad Dos Brazos',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738745498/PERSONATGES/Chad/mdrk0l34trscjwesqhiw.png',3,3);

-- Dondochakka
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Dondochakka',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739005969/PERSONATGES/Dondochakka/eutna9zoqpmcmiekzham.png',4,4);

-- Ganju
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ganju',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738747150/PERSONATGES/Ganju/w4egvovfzsyn7v04pgwz.png',5,5);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ganju Jabali',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738747153/PERSONATGES/Ganju/ia73uvbqm7dhyrssoeak.png',5,5);

-- Gin
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Gin',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738748837/PERSONATGES/Gin/wh66nqhnrm1lcdttn8fp.png',6,6);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Gin Shikai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739186756/PERSONATGES/Gin/y3fu5oagtsgz7fnva45x.png',6,6);

-- Hitsugaya
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Hitsugaya',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183655/PERSONATGES/Hitsugaya/uosnidgu9stveoqhbbck.png',7,7);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Hitsugaya Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183688/PERSONATGES/Hitsugaya/uoad2cs9tzce69vefgp5.png',7,7);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Hitsugaya Bankai Bo',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183697/PERSONATGES/Hitsugaya/qudf6clurwaj4fcmvaiv.png',7,7);

-- Hiyori
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Hiyori',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738745359/PERSONATGES/Hiyori/dveh6v0q6qoldb5cmimj.png',8,8);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Hiyori Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738745344/PERSONATGES/Hiyori/lkx3hrzxm7yrpgcawcpc.png',8,8);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Hiyori Vanisher',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738745362/PERSONATGES/Hiyori/hhlm4aqrjno4thslm7dq.png',8,8);

-- Ichigo
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichigo Estudiant',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182059/PERSONATGES/Ichigo/gmo3rvenlzlodi8zcx8n.png',9,9);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichigo',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182180/PERSONATGES/Ichigo/ji7ztcfa2crnxr1ofhbh.png',9,9);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichigo Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739181761/PERSONATGES/Ichigo/tzmgpuxujb7bw7obotok.png',9,9);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichigo Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739181685/PERSONATGES/Ichigo/clcju9ah22eg5fhzz6kw.png',9,9);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichigo Mascara',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182041/PERSONATGES/Ichigo/bdtmknwfy3dmqv5hxtzz.png',9,9);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichigo Hollow',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182387/PERSONATGES/Ichigo/lbt5jxmdwvek0fe2frhe.png',9,9);

-- Ikkaku
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ikkaku',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185628/PERSONATGES/Ikkaku/vxb0vhqwe2dyoncjui7x.png',10,10);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ikkaku Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185637/PERSONATGES/Ikkaku/umshbnsnfyqeqf4vaomy.png',10,10);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ikkaku Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185651/PERSONATGES/Ikkaku/qpbughb1ft3ys45lfm5t.png',10,10);

-- Ishida
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ishida',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185521/PERSONATGES/Ishida/yztx5yojgc4kltjefozk.png',11,11);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ishida Arco Gross',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185563/PERSONATGES/Ishida/uh5n856dwamulgtex64i.png',11,11);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ishida Quincy',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185583/PERSONATGES/Ishida/xzbhniaqxcpfr95jkrqg.png',11,11);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ishida Quingy Xetat',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185586/PERSONATGES/Ishida/bniwn31r7t6j7ytqus9l.png',11,11);

-- Kenpachi
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kenpachi',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183156/PERSONATGES/Kenpachi/pefpld0v2afncevimkqk.png',12,12);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kenpachi Desenvainat',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183170/PERSONATGES/Kenpachi/tk5i771juittiwdsp2my.png',12,12);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kenpachi Aura',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183175/PERSONATGES/Kenpachi/lzd9nkrzdhqlhfds8f53.png',12,12);

-- Kensei
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kensei',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749119/PERSONATGES/Kensei/gayutmsepkp0mysgkdjy.png',13,13);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kensei Shikai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749118/PERSONATGES/Kensei/lvnpsl9sfsfxi5vim9uv.png',13,13);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kensei Bankai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749118/PERSONATGES/Kensei/slbkoiemhk8xdlzlakqx.png',13,13);

-- Kira
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kira',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738747238/PERSONATGES/Kira/tx9apoywhif7297kvh1c.png',14,14);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kira Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738747241/PERSONATGES/Kira/eqogltgd26attwakzrxj.png',14,14);

-- Komamura
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Komamura Tapat',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183554/PERSONATGES/Komamura/opt8fho8dke2r9xwmidp.png',15,15);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Komamura Destapat',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749647/PERSONATGES/Komamura/zstjqiv7l8ooq7ordnds.png',15,15);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Komamura Hado',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749649/PERSONATGES/Komamura/d1hdx7mlxq7bfpsmr0cx.png',15,15);

-- Kon
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kon',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183737/PERSONATGES/Kon/u1rqlogngtfvqhhsiyhx.png',16,16);

-- Kotetsu
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kotetsu',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749827/PERSONATGES/Kotetsu/xvikwag2y8nbesoyjzgv.png',17,17);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kotetsu Hado',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749827/PERSONATGES/Kotetsu/lhjxevisvseaaoivwswt.png',17,17);

-- Kyoraku
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kyoraku',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183779/PERSONATGES/Kyoraku/p5e0unfump5ltkduwm8p.png',18,18);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kyoraku Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183790/PERSONATGES/Kyoraku/vpvr4kq5qn8atfkcmk7o.png',18,18);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kyoraku Atacant',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183824/PERSONATGES/Kyoraku/cvulrirygiidghyliw7y.png',18,18);

-- Lisa
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Lisa Shinigami',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738748477/PERSONATGES/Lisa/oxxyjfjdnpwhzf9fafx0.png',19,19);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Lisa Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738748477/PERSONATGES/Lisa/hqkissv10rmm4z36g1mm.png',19,19);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kyoraku Vanisher',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738748637/PERSONATGES/Lisa/uslcepal2dqvidnz521g.png',19,19);

-- Love
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Love Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739184323/PERSONATGES/Love/ocumrdqbxbtlwyueivje.png',20,20);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Lisa Shikai Vanisher',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739184304/PERSONATGES/Love/r3rzgidtogexzkekgfel.png',20,20);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Lisa Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739184272/PERSONATGES/Love/ib1jeud5udivmyhdmnn9.png',20,20);

-- Mashiro
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mashiro Shinigami',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749224/PERSONATGES/Mashiro/ojxmbtwlqkhskqk79c9i.png',21,21);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mashiro Kick',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749224/PERSONATGES/Mashiro/t1fhh6aahxfif5u9zcfg.png',21,21);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mashiro Explosion',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749224/PERSONATGES/Mashiro/irepyvys2vag6whllrxa.png',21,21);

-- Matsumoto
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Matsumoto',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185234/PERSONATGES/Matsumoto/v68fygtlhh1lty02lje2.png',22,22);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Matsumoto Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185244/PERSONATGES/Matsumoto/ok5ht45qpxlcbafubemq.png',22,22);

-- Mayuri
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mayuri',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185234/PERSONATGES/Matsumoto/v68fygtlhh1lty02lje2.png',23,23);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mayuri Shikai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185244/PERSONATGES/Matsumoto/ok5ht45qpxlcbafubemq.png',23,23);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mayuri Veneno',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185234/PERSONATGES/Matsumoto/v68fygtlhh1lty02lje2.png',23,23);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mayuri Bankai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739185244/PERSONATGES/Matsumoto/ok5ht45qpxlcbafubemq.png',23,23);

-- Nel
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Nel Petita',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750544/PERSONATGES/Nel/dq92dkb3jzdahkw0ftax.png',24,24);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Nel Gran amb Funda',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750544/PERSONATGES/Nel/hhr17pqthbqczoko2iry.png',24,24);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Nel Gran',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750545/PERSONATGES/Nel/mpopbeetzhzekqcwwxft.png',24,24);

-- Orihime
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Orihime',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749960/PERSONATGES/Orihime/hat2nzizd5m8bhbilkct.png',25,25);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Orihime Estudiant',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749959/PERSONATGES/Orihime/h2gzefbsf35xtnsx6fnu.png',25,25);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Orihime Atacant',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749961/PERSONATGES/Orihime/rdzkexszvis4qzafba8f.png',25,25);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Orihime Escut',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749960/PERSONATGES/Orihime/osghj51xq5mmigr5wfpn.png',25,25);

-- Peshe
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Peshe',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183594/PERSONATGES/Pesche/qkdqja0dcd6ss2dxv5pu.png',26,26);

-- Renji
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Renji',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183452/PERSONATGES/Renji/mkvclgg8eqgyoywbl2cs.png',27,27);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Renji Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183425/PERSONATGES/Renji/jyvwafy3fugim1otawdz.png',27,27);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Renji Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183515/PERSONATGES/Renji/g724eqoho0ykrfp8fphu.png',27,27);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Renji Bankai Dispar',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183490/PERSONATGES/Renji/zgh7rqeahmdmhloddqrz.png',27,27);

-- Rukia
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Rukia',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739180950/PERSONATGES/Rukia/fcpkzkzatzgahcm239bo.png',28,28);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Rukia Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739180951/PERSONATGES/Rukia/gfnwonqul5qs1sy886ts.png',28,28);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Rukia Shikai Capa',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739180951/PERSONATGES/Rukia/e1tvpo0lxdcaywdudypx.png',28,28);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Rukia Shikai Vent',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739180951/PERSONATGES/Rukia/cejqcwiimx7lubgrmf9h.png',28,28);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Rukia Bankai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739180954/PERSONATGES/Rukia/qqwu0oodurq3dszkxi3c.png',28,28);

-- Shinji
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Shingi',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183991/PERSONATGES/Shinji/cucifqxd8qdiwoldjguh.png',29,29);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Shingi Boina',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739184023/PERSONATGES/Shinji/qmcbolitojgmjzg3elg4.png',29,29);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Shingi Vanisher',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739184027/PERSONATGES/Shinji/mdoq2oxsrkl1rproydz4.png',29,29);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Shingi Shikai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1740047128/PERSONATGES/Shinji/ovd5zcftxu9dwso7fccx.png',29,29);

-- Soi Fon
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Soi Fon',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739184100/PERSONATGES/Soi%20Fon/ial3gs8g1powpbzhvjde.png',30,30);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Soi Fon Shikai',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1740047456/PERSONATGES/Soi%20Fon/nw7blyxfr6bu47wx52gb.png',30,30);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Soi Fon Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739184170/PERSONATGES/Soi%20Fon/vwqgvpbcpdvv3bupgsdg.png',30,30);

-- Tosen
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Tosen Postura',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750065/PERSONATGES/Tosen/mughxlivodxmirvk4di2.png',31,31);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Tosen GiraEspassa',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750065/PERSONATGES/Tosen/soditvigiwx61acnqsih.png',31,31);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Tosen Cercle',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750066/PERSONATGES/Tosen/xidcguayuufhyq1d1k1e.png',31,31);

-- Ukitake
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ukitake Espassa',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183846/PERSONATGES/Ukitake/hmaz4lsy16lrlyuwjve0.png',32,32);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ukitake Shikai Creuat',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183879/PERSONATGES/Ukitake/qwnijwyh90mlrj956gln.png',32,32);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ukitake Shikai Vent',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183885/PERSONATGES/Ukitake/frerxscwueolrzwp9off.png',32,32);

-- Unohana
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Unohana Espassa',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749512/PERSONATGES/Unohana/sbiwabaxxi3kffibfsjc.png',33,33);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Urahara Kido Groc',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749512/PERSONATGES/Unohana/em1o1s4m8cga6sy7ynof.png',33,33);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Urahara Kido Blau',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749511/PERSONATGES/Unohana/p8dklvrnl1d7buqa8bnu.png',33,33);

-- Urahara
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Urahara Tenda',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182581/PERSONATGES/Urahara/sugkqhjbwxgl3heipsqz.png',34,34);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Urahara Capita',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182598/PERSONATGES/Urahara/tlovl7bksfvvxdyvzept.png',34,34);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Urahara Presio',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182771/PERSONATGES/Urahara/sklxlr7hernseesvo6du.png',34,34);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Urahara Shikai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182796/PERSONATGES/Urahara/qxdr3jtxhisf8niga5lq.png',34,34);

-- Ushoda
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ushoda Escut Blau',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749371/PERSONATGES/Ushoda/djo9yesnwsmexoqk05wd.png',35,35);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ushoda Relaxat ',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749371/PERSONATGES/Ushoda/knw2mtk6npfoczeezd8x.png',35,35);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ushoda Kido',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738749370/PERSONATGES/Ushoda/qscguo7ivox3gc3ofdqd.png',35,35);

-- Yamamoto
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yamamoto Puny de Foc',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183930/PERSONATGES/Yamamoto/t5npfrkrygsjppkqcpay.png',36,36);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yamamoto Shikai ',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183920/PERSONATGES/Yamamoto/vsrrwursumra0w6yhbzo.png',36,36);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yamamoto Capita General',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739183914/PERSONATGES/Yamamoto/i5uheu0i9jdj6n4lhjga.png',36,36);

-- Yoruichi
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yoruichi Moix',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182453/PERSONATGES/Yoruichi/f7yymt7imts3ysmzoinl.png',37,37);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yoruichi',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182499/PERSONATGES/Yoruichi/lvqyrbelav64ebcwlzma.png',37,37);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yoruichi Capitana',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182497/PERSONATGES/Yoruichi/ljzopo4bi0uil270ap1y.png',37,37);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yoruichi Aizen',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739182453/PERSONATGES/Yoruichi/f7yymt7imts3ysmzoinl.png',37,37);

-- Yumichika
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yumichika',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739179733/PERSONATGES/Yumichika/lzggo85qttyfa69ekxdp.png',38,38);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yumichika Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739179732/PERSONATGES/Yumichika/cfcrospepuva0wanfg9s.png',38,38);

-- Aaroniero
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aaroniero',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750526/ENEMICS/Aaroniero/z4fqfamh5v25zxqipm9o.png',40,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Aaroniero Transformat',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750526/ENEMICS/Aaroniero/b4x6ywbhdv4hcffp1n8k.png',40,NULL);

-- Abirama
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Abirama',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738750570/ENEMICS/Abirama/rky6xagsypmdrlbak79x.png',41,NULL);

-- Apache
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Apache',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738744526/ENEMICS/Apache/j3uet8qyl1ml8oj1pyms.png',42,NULL);

-- Barragan
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Barragan',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751376/ENEMICS/Barragan/zz4aenpngmwbkjy0y85i.png',43,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Barragan Mort',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751376/ENEMICS/Barragan/mkljvu1vgctyp7htgya6.png',43,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Barragan Destral',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751376/ENEMICS/Barragan/w46mpcryjchzfntldalc.png',43,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Barragan Peste',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751376/ENEMICS/Barragan/nypa6hkykd9gz6ioh89w.png',43,NULL);

-- Coyote
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Coyote',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751457/ENEMICS/Coyote/jeaf2suejhl6wkpbzgi5.png',44,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Coyote Zero',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751457/ENEMICS/Coyote/jyosrh7etllhqidjrord.png',44,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Coyote Pistoles',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751457/ENEMICS/Coyote/pakfb97dwux6g7mrd51h.png',44,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Coyote Llops',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751457/ENEMICS/Coyote/ffivfwd6ti3jzxfaqxg4.png',44,NULL);

-- Gin
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Gin Dolent',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751631/ENEMICS/Gin/iiyoajmv8i5xjiq9aw6v.png',6,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Gin Dolent Bankai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751631/ENEMICS/Gin/s3xov08jmket3ndqwazi.png',6,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Gin Assegut',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751631/ENEMICS/Gin/nebvojudeqkazcvqj9ia.png',6,NULL);

-- Granz
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Granz',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751739/ENEMICS/Granz/pqyrdei9n8ukhuokfaho.png',45,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Granz Veneno',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751740/ENEMICS/Granz/wblfro1adjr0lm2gp7bj.png',45,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Granz Alliberat',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751740/ENEMICS/Granz/hvqt6g5r2uf4cjvzoiac.png',45,NULL);

-- Grimmjow
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Grimmjow',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751935/ENEMICS/Grimmjow/lxry8jglgipqx7wd2tbd.png',46,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Grimmjow Zero',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751935/ENEMICS/Grimmjow/zzpvwdzah2ub1parkguq.png',46,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Grimmjow Espasa',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751934/ENEMICS/Grimmjow/nyp7ujcbhap05s6wherw.png',46,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Grimmjow Pantera',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751935/ENEMICS/Grimmjow/bsprj66lchcpht3rmche.png',46,NULL);

-- Halibel
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Halibel',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752058/ENEMICS/Halibel/xm9ur0fotmq7dzu79fam.png',47,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Halibel Espasa',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752058/ENEMICS/Halibel/fbqruu6azsmhkxrcnzhi.png',47,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Halibel Alliberada',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752059/ENEMICS/Halibel/on9nbuxkcie02czeje1i.png',47,NULL);

-- Lilynette
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Lilynette',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752169/ENEMICS/Lilynette/hhfijgqiwp6djy55q2jr.pngg',48,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Lilynette Espasa',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752169/ENEMICS/Lilynette/uvmy8vtmllrlcnunpzuy.png',48,NULL);

-- Loly
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Loly',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738744463/ENEMICS/Loly/poei8w1ogzpwdrnkefhi.png',49,NULL);

-- MenosGrande
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Menos Grande',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1739190308/ENEMICS/MenosGrande/haug5adpwltg2bfqogq4.png',50,NULL);

-- Mila
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Mila',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738744565/ENEMICS/Mila/mhsntt8slmhn1zl3atby.png',51,NULL);

-- Nnoitra
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Nnoitra',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752266/ENEMICS/Nnoitra/eoshvimsvakiuezpqzle.png',52,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Nnoitra Espasa',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752266/ENEMICS/Nnoitra/e4voegzvrwdykzicsm0u.png',52,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Nnoitra Alliberat',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752267/ENEMICS/Nnoitra/bxenfpm3hpunw9ykgvoz.png',52,NULL);

-- Tosen
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Tosen Dolent Zero',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752356/ENEMICS/Tosen/tgjcg2fydydej35o80n6.png',31,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Tosen Mosca',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752356/ENEMICS/Tosen/mbrjfxqbaxbabnx4iulo.png',31,NULL);

-- Ulquiorra
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ulquiorra',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751946/ENEMICS/Ulquiorra/puiabnvbiheqd817nx7g.png',53,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ulquiorra Murcielago',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751947/ENEMICS/Ulquiorra/t7mbiao8md17uvw9xjc4.png',53,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ulquiorra Murcielago Fase 2',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738751947/ENEMICS/Ulquiorra/gglou6tdqfapflmkizz2.png',53,NULL);

-- Wonderweiss
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Wonderweiss',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752418/ENEMICS/Wonderweiss/za8tndaznj9jmkdnjeig.png',54,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Wonderweiss Alliberat',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752417/ENEMICS/Wonderweiss/i5wtzpxes3hsyfbfcjoq.png',54,NULL);

-- Yammy
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yammy',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752510/ENEMICS/Yammy/dhf6otsziwifxd0cdmkv.png',55,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yammy Pegant',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752510/ENEMICS/Yammy/wmgdq8qfeme8qwkzw736.png',55,NULL);

-- Zommari
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Zommari',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752560/ENEMICS/Zommari/rnp3gbuo4v9trnfwcwbt.png',56,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Zommari Alliberat',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1738752560/ENEMICS/Zommari/rnp3gbuo4v9trnfwcwbt.png',56,NULL);


-- SKINS ARMES
INSERT INTO SKINS_ARMES(skin, arma) VALUES
-- Aizen
(1, 10),  -- Aizen Bo - Kyoka Suigetsu (Arma base)
(2, 10),  -- Aizen Dolent Ulleres - Kyoka Suigetsu (Arma base)
(3, 11),  -- Aizen Dolent Arrancar - Kyoka Suigetsu (Arma base)
(4, 11),  -- Aizen Dolent Xetat - Kyoka Suigetsu (Arma base)
(5, 11),  -- Aizen Dolent Garganta - Kyoka Suigetsu (Arma base)
(6, 11),  -- Aizen Dolent Hogyoku - Kyoka Suigetsu (Arma base)

-- Byakuya
(7, 13),  -- Byakuya - Senbonzakura (Arma base)
(8, 14),  -- Byakuya Shikai - Senbonzakura (Shikai)
(9, 14),  -- Byakuya Senbonzakura - Senbonzakura Kageyoshi (Bankai)
(10, 15), -- Byakuya Bankai - Senbonzakura Kageyoshi (Bankai)

-- Chad
(11, 16), -- Chad - Braç Esquerre del Dimoni
(12, 16), -- Chad Derecho - Braç Esquerre del Dimoni
(13, 16), -- Chad Derecho Gigante - Braç Esquerre del Dimoni
(14, 16), -- Chad Dos Brazos - Braç Esquerre del Dimoni

-- Dondochakka
(15, 17), -- Dondochakka - Kidou Baix

-- Ganju
(16, 18), -- Ganju - Kidou
(17, 18), -- Ganju Jabali - Kidou

-- Gin
(18, 19), -- Gin - Shinso (Arma base)
(19, 20), -- Gin Shikai - Shinso (Shikai)

-- Hitsugaya
(20, 22), -- Hitsugaya - Hyorinmaru (Arma base)
(21, 24), -- Hitsugaya Bankai - Hyorinmaru (Shikai)
(22, 24), -- Hitsugaya Bankai Bo - Daiguren Hyorinmaru (Bankai)

-- Hiyori
(23, 25), -- Hiyori - Kubikiri Orochi (Arma base)
(24, 25), -- Hiyori Shikai - Kubikiri Orochi (Arma base)
(25, 25), -- Hiyori Vanisher - Kubikiri Orochi (Arma base)

-- Ichigo
(26, 26), -- Ichigo Estudiant - Zangetsu (Arma base)
(27, 26), -- Ichigo - Zangetsu (Arma base)
(28, 27), -- Ichigo Shikai - Zangetsu (Shikai)
(29, 28), -- Ichigo Bankai - Tensa Zangetsu (Bankai)
(30, 28), -- Ichigo Mascara - Tensa Zangetsu (Bankai)
(31, 28), -- Ichigo Hollow - Tensa Zangetsu (Bankai)

-- Ikkaku
(32, 29), -- Ikkaku - Hozukimaru (Arma base)
(33, 30), -- Ikkaku Shikai - Hozukimaru (Shikai)
(34, 31), -- Ikkaku Bankai - Ryumon Hozukimaru (Bankai)

-- Ishida
(35, 32), -- Ishida - Seele Schneider
(36, 32), -- Ishida Arco Gross - Seele Schneider
(37, 32), -- Ishida Quincy - Seele Schneider
(38, 32), -- Ishida Quingy Xetat - Seele Schneider

-- Kenpachi
(39, 33), -- Kenpachi - Nozarashi (Arma base)
(40, 34), -- Kenpachi Desenvainat - Nozarashi (Shikai)
(41, 35), -- Kenpachi Aura - Nozarashi (Bankai)

-- Kensei
(42, 36), -- Kensei - Tachikaze (Arma base)
(43, 37), -- Kensei Shikai - Tachikaze (Shikai)
(44, 38), -- Kensei Bankai - Tachikaze (Bankai)

-- Kira
(45, 39), -- Kira - Wabisuke (Arma base)
(46, 40), -- Kira Shikai - Wabisuke (Shikai)

-- Komamura
(47, 41), -- Komamura Tapat - Tenken (Arma base)
(48, 42), -- Komamura Destapat - Tenken (Shikai)
(49, 43), -- Komamura Hado - Kokujo Tengen Myo-o (Bankai)

-- Kon
(50, 44), -- Kon - Força pròpia

-- Kotetsu
(51, 45), -- Kotetsu - Kidou Curatiu
(52, 45), -- Kotetsu Hado - Kidou Curatiu

-- Kyoraku
(53, 46), -- Kyoraku - Katen Kyokotsu (Arma base)
(54, 47), -- Kyoraku Shikai - Katen Kyokotsu (Shikai)
(55, 48), -- Kyoraku Atacant - Katen Kyokotsu: Karamatsu Shinju (Bankai)

-- Lisa
(56, 49), -- Lisa Shinigami - Haguro Tonbo (Arma base)
(57, 49), -- Lisa Shikai - Haguro Tonbo (Arma base)
(58, 49), -- Kyoraku Vanisher - Haguro Tonbo (Arma base)

-- Love
(59, 50), -- Love Shikai - Tengumaru (Arma base)
(60, 51), -- Lisa Shikai Vanisher - Tengumaru (Shikai)
(61, 51), -- Lisa Bankai - Tengumaru (Shikai)

-- Mashiro
(62, 52), -- Mashiro Shinigami - Hollowificació
(63, 52), -- Mashiro Kick - Hollowificació
(64, 52), -- Mashiro Explosion - Hollowificació

-- Matsumoto
(65, 53), -- Matsumoto - Haineko (Arma base)
(66, 54), -- Matsumoto Shikai - Haineko (Shikai)

-- Mayuri
(67, 55), -- Mayuri - Ashizogi Jizo (Arma base)
(68, 56), -- Mayuri Shikai - Ashizogi Jizo (Shikai)
(69, 57), -- Mayuri Veneno - Konjiki Ashizogi Jizo (Bankai)
(70, 57), -- Mayuri Bankai - Konjiki Ashizogi Jizo (Bankai)

-- Nel
(71, 58), -- Nel Petita - Gamuza
(72, 58), -- Nel Gran amb Funda - Gamuza
(73, 58), -- Nel Gran - Gamuza

-- Orihime
(74, 59), -- Orihime - Santel·la
(75, 59), -- Orihime Estudiant - Santel·la
(76, 59), -- Orihime Atacant - Santel·la
(77, 59), -- Orihime Escut - Santel·la

-- Pesche
(78, 60), -- Peshe - Kidou Cero

-- Renji
(79, 61), -- Renji - Zabimaru (Arma base)
(80, 62), -- Renji Shikai - Zabimaru (Shikai)
(81, 63), -- Renji Bankai - Hihio Zabimaru (Bankai)
(82, 63), -- Renji Bankai Dispar - Hihio Zabimaru (Bankai)

-- Rukia
(83, 64), -- Rukia - Sode no Shirayuki (Arma base)
(84, 65), -- Rukia Shikai - Sode no Shirayuki (Shikai)
(85, 65), -- Rukia Shikai Capa - Sode no Shirayuki (Shikai)
(86, 66), -- Rukia Shikai Vent - Hakka no Togame (Bankai)
(87, 66), -- Rukia Bankai - Hakka no Togame (Bankai)

-- Shinji
(88, 67), -- Shingi - Sakanade (Arma base)
(89, 68), -- Shingi Boina - Sakanade (Shikai)
(90, 68), -- Shingi Vanisher - Sakanade (Shikai)
(91, 68), -- Shingi Shikai - Sakanade (Shikai)

-- Soi Fon
(92, 69), -- Soi Fon - Suzumebachi (Arma base)
(93, 70), -- Soi Fon Shikai - Suzumebachi (Shikai)
(94, 71), -- Soi Fon Bankai - Jakho Raikoben (Bankai)

-- Tosen
(95, 72), -- Tosen Postura - Suzumushi (Arma base)
(96, 73), -- Tosen GiraEspassa - Suzumushi (Shikai)
(97, 74), -- Tosen Cercle - Suzumushi Tsuishiki: Enma Korogi (Bankai)

-- Ukitake
(98, 75), -- Ukitake Espassa - Sogyo no Kotowari (Arma base)
(99, 76), -- Ukitake Shikai Creuat - Sogyo no Kotowari (Shikai)
(100, 76), -- Ukitake Shikai Vent - Sogyo no Kotowari (Shikai)

-- Unohana
(101, 77), -- Unohana Espassa - Minazuki (Arma base)
(102, 78), -- Urahara Kido Groc - Minazuki (Shikai)
(103, 79), -- Urahara Kido Blau - Minazuki (Bankai)

-- Urahara
(104, 80), -- Urahara Tenda - Benihime (Arma base)
(105, 81), -- Urahara Capita - Benihime (Shikai)
(106, 81), -- Urahara Presio - Benihime (Shikai)
(107, 81), -- Urahara Shikai - Benihime (Shikai)

-- Ushoda
(108, 82), -- Ushoda Escut Blau - Kidou Hollow
(109, 82), -- Ushoda Relaxat - Kidou Hollow
(110, 82), -- Ushoda Kido - Kidou Hollow

-- Yamamoto
(111, 83), -- Yamamoto Puny de Foc - Ryujin Jakka (Arma base)
(112, 84), -- Yamamoto Shikai - Ryujin Jakka (Shikai)
(113, 85), -- Yamamoto Capita General - Zanka no Tachi (Bankai)

-- Yoruichi
(114, 86), -- Yoruichi Moix - Kido Shunko
(115, 86), -- Yoruichi - Kido Shunko
(116, 86), -- Yoruichi Capitana - Kido Shunko
(117, 86), -- Yoruichi Aizen - Kido Shunko

-- Yumichika
(118, 87), -- Yumichika - Fuji Kujaku (Arma base)
(119, 88); -- Yumichika Bankai - Fuji Kujaku (Shikai)



-- HOLLOWS GO REMASTERED

-- INSERTS FETS PER EN MIQUEL SANSÓ TORRES
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Riruka', 600, 65)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Yhwach', 1000, 180)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Ichibe Hyosube', 1100, 175)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Kirio Hikifune', 1200, 150)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Asguiaro Ebern', 650, 70)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Quilge Opie', 700, 85)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Chojiro Tadaoki', 900, 110)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Ryuken Ishida', 800, 100)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Lille Barro', 1000, 165)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Jugram Haschwalth', 1050, 170)
insert into personatges(nom, vida_base, mal_base) values('Isshin Kurosaki', 850, 100)
insert into personatges(nom, vida_base, mal_base) values('Yachiru', 600, 65)
insert into personatges(nom, vida_base, mal_base) values('Rōjūrō Ōtoribashi', 900, 110)

-- INSERTS FETS PER N'ALBERT GALÁN CÀNAVES
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('NaNaNa', 700, 70)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Äs Nödt', 750, 85)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Mask De Masculine', 800, 90)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Giselle Gewelle', 800, 75)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Bambietta Basteaban', 600, 90)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES ('Robert Accutrone', 600, 75)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES ('Candice Catnipp', 700, 80)
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES ('Oh-Etsu Nimaiya', 1100, 170)
insert into personatges(nom, vida_base, mal_base) values('Kūgo Ginjō', 700, 80)
insert into personatges(nom, vida_base, mal_base) values('Jackie Tristan', 650, 70)

-- INSERTS FETS PER ÀNGEL RUBIO OLIVER
INSERT INTO PERSONATGES(nom, vida_base, mal_base) VALUES('Bazz-B', 760, 115),('Senjumaru Shutara',1100, 165),('Gremmy Thoumeaux',1000,145),('Askin Nakk Le Vaar', 1000, 90),('Meninas', 700, 85),('Masaki Kurosaki', 600, 110),('Cang Du', 700, 80)
insert into personatges(nom, vida_base, mal_base) values('Shūkurō Tsukishima', 650, 75)
insert into personatges(nom, vida_base, mal_base) values('Driscoll Berci', 800, 115)
*/
