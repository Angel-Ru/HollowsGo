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

-- INSERTS DE SKINS FETS PER MIQUEL SANSÓ

--Riruka
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Riruka',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275824/PERSONATGES/Riruka/d2cqpyghyjainwvwbxyl.png',75,NULL);

-- Ichibe Hyosube
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichibe',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277834/PERSONATGES/Ichibe/zdajpd9uijppl7ofmjtj.png',77,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ichibe Bankai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277816/PERSONATGES/Ichibe/oxzpt7st0gdvq6h7fnuw.png',77,NULL);

-- Kirio Hikifune
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kirio',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277632/PERSONATGES/Kirio/uwuht1xskff6mbwifdl4.png',78,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kirio Prima',4,'',78,NULL);

-- Chojiro Tadaoki
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Chojiro Jove',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275747/PERSONATGES/Chojiro/zezsekgqwu0f4fvfsbwq.png',81,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Chojiro Bankai',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275748/PERSONATGES/Chojiro/srfadni62w4oobghiafo.png',81,NULL);

-- Ryūken Ishida
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ryūken',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744616813/PERSONATGES/Ryuken/cf8rlvm3ycygpodlxnjq.png',82,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Ryūken Disparant',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744616813/PERSONATGES/Ryuken/j2zram9bkm4iqwlhzjik.png',82,NULL);

-- Isshin Kurosaki
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Isshin',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744358653/1602-c2759e22-b290-43cd-96e6-029d767ae5ff_pcgrfa.png',85,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Isshin Jove',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744358655/1753-54cecd36-4db6-4dad-b0c2-dfb2aff706d1_ilp44x.png',85,NULL);

-- Yachiru
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Yachiru',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277068/PERSONATGES/Yachiru/umnzcpgkgmwa9hetrph7.png',86,NULL);

-- Rōjūrō Ōtoribashi "Rose" 
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Rose',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277428/PERSONATGES/Rojuro/jc8svrcedkeuzvsjjqnb.png',87,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Rose Capità',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277443/PERSONATGES/Rojuro/xabdnbudi5vlruejguoz.png',87,NULL);

-- Oh-Etsu Nimaiya
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Oh-Etsu',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277719/PERSONATGES/Oh/cywqorfdszalf4hpjwkd.png',74,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Oh-Etsu Apuntant',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277774/PERSONATGES/Oh/ymiyacu0yu5qbp1bf0h1.png',74,NULL);

-- Kūgo Ginjō
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Kūgo Ginjō',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275776/PERSONATGES/Ginjo/j0hoii1ypzvxq0o6skxm.png',88,NULL);

-- Jackie Tristan
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Jackie',1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275776/PERSONATGES/Ginjo/j0hoii1ypzvxq0o6skxm.png',88,NULL);


-- INSERTS DE SKINS FETS PER ÀNGEL RUBIO

-- Senjumaru Shutara
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Senjumaru',3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277548/PERSONATGES/Senjumaru/dnagivpuc9pxccaggbiv.png',61,NULL);
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Senjumaru Bankai',4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277533/PERSONATGES/Senjumaru/fpts8za3sj5g0mg8y5ls.png',61,NULL);

-- Shūkurō Tsukishima
insert into SKINS(nom, categoria, imatge,personatge,atac) VALUES('Tsukushima',2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275765/PERSONATGES/Tsukishima/qlyfi5q8tb6ld8nndvsi.png',61,NULL);

-- Äs Nödt
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Äs Nödt', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275520/QUINCIES/%C3%84s/icsfiu7x0dvbnzioh6kv.png', 68, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Äs Nödt Vollständig', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275520/QUINCIES/%C3%84s/wckhskjiwcovhr0djf2o.png', 68, NULL)

--Askin Nakk
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Askin Nakk', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275529/QUINCIES/Askin/w7haazedhcayuhudosif.png', 63, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Askin Nakk Vollständig', 3, 'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275529/QUINCIES/Askin/vfqw1owjlbsnpcg3e7mc.png', 63, NULL)

--Bambietta
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Bambietta', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275547/QUINCIES/Bambietta/foqqmwtrg9vvuxbwdlkh.png', 71, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Bambietta Zombie', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275547/QUINCIES/Bambietta/wota2etju1ymjjozwdmg.png', 71, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Bambietta Vollständig', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275548/QUINCIES/Bambietta/pu96ltxvk088cp71kh7s.png', 71, NULL)

--Bazz B
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Bazz B', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275554/QUINCIES/Bazz/sz3bcd1qmrn0f0rypm9a.png', 60, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Bazz B Full Fingers', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275554/QUINCIES/Bazz/p87pxcvypvrjqshfshjb.png', 60, NULL)

--Candice
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Candice Catnipp', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275562/QUINCIES/Candice/jakt6jshaeutx4xt8fx2.png', 73, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Candice Catnipp Vollständig', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275561/QUINCIES/Candice/sw8ogfkg52hkmj5f5rfr.png', 73, NULL)

--Cang Du
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Cang Du', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275570/QUINCIES/Cang/w2emaaqjllocntxglnd0.png', 66, NULL)

--Driscoll Berci
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Driscoll Berci', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275578/QUINCIES/Driscoll/u9ie4wdvtgwh4bybsclk.png', 91, NULL)

--Ebern
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Asguiaro Ebern', 1,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275586/QUINCIES/Ebern/m2hjdkzz5s05tvlizy77.png', 79, NULL)

--Giselle
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Giselle Gewelle', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275595/QUINCIES/Giselle/o0zifzybc2lhxsd94svc.png', 70, NULL)


-- INSERTS DE SKINS FETS PER ALBERT GALÀN

--Gremmy
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Gremmy Thoumeaux', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275605/QUINCIES/Gremmy/xgxavc2f0hc8pbqej9rl.png', 62, NULL)


--Hashwalth
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Jugram Haschwalth', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275612/QUINCIES/Haschwalth/eqc7sdsainjoasvf3jem.png', 84, NULL)

--Ishida
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Ishida Uryu Casual', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275622/QUINCIES/Ishida/itvy0lxk7ujnkjwyfy88.png', 11, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Ishida Uryu Wandenreich', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275622/QUINCIES/Ishida/glstla3g2d3mykqtc1l1.png', 11, NULL)

--Lille
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Lille Barro', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275629/QUINCIES/Lille/lato30xehm0vsffhycx4.png', 83, NULL)

--Masaki
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Masaki Kurosaki', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275637/QUINCIES/Masaki/tue4iezc9btwsgsdtosq.png', 65, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Masaki Kurosaki Salvadora', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275638/QUINCIES/Masaki/kxw5cikem45wd1upzgw9.png', 65, NULL)

--Mask
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Mask De Masculine Vollständig', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275648/QUINCIES/Mask/jrlayer6rt6tffjnotjy.png', 69, NULL)

--Meninas
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Meninas McAllon', 2,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275658/QUINCIES/Meninas/lnbuscvfbbhqeq9cadc7.png', 64, NULL)

--Quilge
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Quilge Opie Vollständig', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275680/QUINCIES/Quilge/uiqnrgsw6idsfcqpvbfl.png', 80, NULL)

--Robert
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Robert Accutrone', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744616489/QUINCIES/Robert/lr1io362bvanumwh1d0h.png', 72, NULL)

--Yhwach
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Yhwach', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275950/QUINCIES/Yhwach/zguftxszsacvmbt6krws.png', 76, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Yhwach Mimihagi', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275950/QUINCIES/Yhwach/xmpcrotrn1ih90dxxgyn.png', 76, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Yhwach Forma Final', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744275951/QUINCIES/Yhwach/t0vyonrwkiyyryipnnzx.png', 76, NULL)


-- INSERTS D'SKINS DELS PERSONATGES QUE JA ESTAVEN INSERITS

-- INSERTS DE SKINS FETS PER ÀNGEL RUBIO
--Ichigo(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Ichigo (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276237/PERSONATGES/Ichigo/ae7sofaf7izulwc6opii.png', 9, NULL)

--Aizen(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Aizen (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276013/PERSONATGES/Aizen/e3ilurbqyhneqi9lxhm9.png', 1, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Aizen Yokoso', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276027/PERSONATGES/Aizen/zm84przllasfq61tfx5u.png', 1, NULL)

--Byakuya(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Byakuya (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276056/PERSONATGES/Byakuya/rjvkww2d102fy1fzw0ob.png', 2, NULL)

--Chad(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Chad (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276100/PERSONATGES/Chad/nwfay0yahixhvlutzgxk.png', 3, NULL)

--Toshiro Hitsugaya(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Hitsugaya (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276162/PERSONATGES/Hitsugaya/kyue76nnduvrwhjlo0pd.png', 7, NULL)

--Kenpachi(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Kenpachi (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276296/PERSONATGES/Kenpachi/lgaoududyghen8bhkews.png', 12, NULL)

--Kensei(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Kensei (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276321/PERSONATGES/Kensei/abb1wmjy7rcg4anotkwg.png', 13, NULL)


-- INSERTS DE SKINS FETS PER ALBERT GALÀN

--Komamura(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Komamura (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276392/PERSONATGES/Komamura/lv9g9kyrexh9a4mamfnr.png', 15, NULL)

--Kyoraku(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Kyoraku (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276458/PERSONATGES/Kyoraku/w84baxxysaluj9cixppp.png', 18, NULL)

--Matsumoto(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Matsumoto (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276914/PERSONATGES/Matsumoto/ukg8doaukzvy0rfcvkqn.png', 22, NULL)

--Mayuri(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Mayuri (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744277164/PERSONATGES/Mayuri/whd3yhyyrz7dhwq65vm4.png', 23, NULL)

--Orihime(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Orihime (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276536/PERSONATGES/Orihime/fpn7kl58h2xnshd14fcf.png', 25, NULL)

--Renji(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Renji (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276599/PERSONATGES/Renji/zbjygqzin9if2ua9eh1d.png', 27, NULL)

--Rukia(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Rukia (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276636/PERSONATGES/Rukia/gjxrillov8kshsyzxus5.png', 28, NULL)


-- INSERTS DE SKINS FETS PER MIQUEL SANSÓ

--Shinji(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Shinji (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276670/PERSONATGES/Shinji/dv5fsded4mtjvvnydbft.png', 29, NULL)

--Soi Fon(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Soi Fon (TYBW)', 3,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276692/PERSONATGES/Soi%20Fon/eppvocy6uyssoosgezol.png', 30, NULL)

--Unohana(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Unohana (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276758/PERSONATGES/Unohana/b1shijhenfnhgioli0qo.png', 33, NULL)

--Urahara(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Urahara (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276798/PERSONATGES/Urahara/sixqptqwrpttabqbpvrt.png', 34, NULL)

--Yamamoto(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Yamamoto (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276837/PERSONATGES/Yamamoto/c9uu12carjc9rscmuvyi.png', 36, NULL)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Yamamoto (Jove)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276833/PERSONATGES/Yamamoto/cqqnmc0mn47tco4knvjo.png', 36, NULL)

--Yoruichi(Thousand Year War Blood)
INSERT INTO SKINS(nom, categoria, imatge, personatge, atac) VALUES('Yoruichi (TYBW)', 4,'https://res.cloudinary.com/dkcgsfcky/image/upload/v1744276887/PERSONATGES/Yoruichi/a4b2dxwxzz7trkshowq6.png', 37, NULL)
*/


/*
INSERTS FETS PER ALBERT GALÁN
INSERT INTO ATACS(nom, mal) VALUES ('Absorció Memètica', 150);
INSERT INTO ATACS(nom, mal) VALUES ('Huracà Sagnant', 120);
INSERT INTO ATACS(nom, mal) VALUES ('Ullal Salvatge', 130);
INSERT INTO ATACS(nom, mal) VALUES ('Mort Inevitable', 200);
INSERT INTO ATACS(nom, mal) VALUES ('Llops Cero', 160);
INSERT INTO ATACS(nom, mal) VALUES ('Control Genètic', 110);
INSERT INTO ATACS(nom, mal) VALUES ('Garra del Jaguar Blau', 170);
INSERT INTO ATACS(nom, mal) VALUES ('Marea Asfixiant', 140);
INSERT INTO ATACS(nom, mal) VALUES ('Bala Incontrolable', 90);
INSERT INTO ATACS(nom, mal) VALUES ('Urpa Verinosa', 100);
INSERT INTO ATACS(nom, mal) VALUES ('Cero Colossal', 160);
INSERT INTO ATACS(nom, mal) VALUES ('Rugir Reial', 130);
INSERT INTO ATACS(nom, mal) VALUES ('Tall Infinit', 150);
INSERT INTO ATACS(nom, mal) VALUES ('Llança del Raig Negre', 180);
INSERT INTO ATACS(nom, mal) VALUES ('Crit Primigeni', 100);
INSERT INTO ATACS(nom, mal) VALUES ('Erupció de Fúria', 200);
INSERT INTO ATACS(nom, mal) VALUES ('Mirada Absoluta', 140);
INSERT INTO ATACS(nom, mal) VALUES ('Gàbia de Conillets', 70);
INSERT INTO ATACS(nom, mal) VALUES ('Negre Absolut', 190);
INSERT INTO ATACS(nom, mal) VALUES ('Cuina Espiritual', 80);
INSERT INTO ATACS(nom, mal) VALUES ('Espasa de Tempesta', 150);
INSERT INTO ATACS(nom, mal) VALUES ('Dispar Clínic', 100);
INSERT INTO ATACS(nom, mal) VALUES ('Flama Paternal', 130);
INSERT INTO ATACS(nom, mal) VALUES ('Joguina Sagnant', 120);
INSERT INTO ATACS(nom, mal) VALUES ('Simfonia del Caos', 170);
INSERT INTO ATACS(nom, mal) VALUES ('Tall Perfecte', 160);
INSERT INTO ATACS(nom, mal) VALUES ('Espasa de l’Engany', 140);
INSERT INTO ATACS(nom, mal) VALUES ('Cop de Brutícia', 60);
INSERT INTO ATACS(nom, mal) VALUES ('Teixit Celestial', 150);
INSERT INTO ATACS(nom, mal) VALUES ('Fulla Cronològica', 110);
INSERT INTO ATACS(nom, mal) VALUES ('Terror Etern', 180);
INSERT INTO ATACS(nom, mal) VALUES ('Quantitat Letal', 130);
INSERT INTO ATACS(nom, mal) VALUES ('Explosió Desquiciada', 160);
INSERT INTO ATACS(nom, mal) VALUES ('Cinc Dits Llamejants', 150);
INSERT INTO ATACS(nom, mal) VALUES ('Tempesta Elèctrica', 140);
INSERT INTO ATACS(nom, mal) VALUES ('Acer Glacial', 120);
INSERT INTO ATACS(nom, mal) VALUES ('Robatori de Tècnica', 90);
INSERT INTO ATACS(nom, mal) VALUES ('Dispar Fosc', 100);
INSERT INTO ATACS(nom, mal) VALUES ('Sang Infectada', 110);
INSERT INTO ATACS(nom, mal) VALUES ('Imaginació Mortal', 190);
INSERT INTO ATACS(nom, mal) VALUES ('Justícia Bifurcada', 160);
INSERT INTO ATACS(nom, mal) VALUES ('Dispar Diví', 170);
INSERT INTO ATACS(nom, mal) VALUES ('Purificació Cero', 130);
INSERT INTO ATACS(nom, mal) VALUES ('Estrella Justiciera', 140);
INSERT INTO ATACS(nom, mal) VALUES ('Força Delicada', 100);
INSERT INTO ATACS(nom, mal) VALUES ('Gàbia de Reishi', 120);
INSERT INTO ATACS(nom, mal) VALUES ('Tret de la Mort', 110);
INSERT INTO ATACS(nom, mal) VALUES ('Trencament del Futur', 200);

UPDATES:
UPDATE SKINS SET atac = 57 where personatge = 75;
UPDATE SKINS SET atac = 58 where personatge = 77;
UPDATE SKINS SET atac = 59 where personatge = 78;
UPDATE SKINS SET atac = 60 where personatge = 81;
UPDATE SKINS SET atac = 61 where personatge = 82;
UPDATE SKINS SET atac = 62 where personatge = 85;
UPDATE SKINS SET atac = 63 where personatge = 86;
UPDATE SKINS SET atac = 64 where personatge = 87;
UPDATE SKINS SET atac = 65 where personatge = 74;
UPDATE SKINS SET atac = 66 where personatge = 88;
UPDATE SKINS SET atac = 67 where personatge = 89;
UPDATE SKINS SET atac = 68 where personatge = 61;
UPDATE SKINS SET atac = 69 where personatge = 68;
UPDATE SKINS SET atac = 70 where personatge = 63;
UPDATE SKINS SET atac = 71 where personatge = 71;
UPDATE SKINS SET atac = 72 where personatge = 60;
UPDATE SKINS SET atac = 73 where personatge = 73;
UPDATE SKINS SET atac = 74 where personatge = 66;
UPDATE SKINS SET atac = 75 where personatge = 91;
UPDATE SKINS SET atac = 76 where personatge = 79;
UPDATE SKINS SET atac = 77 where personatge = 70;
UPDATE SKINS SET atac = 78 where personatge = 62;
UPDATE SKINS SET atac = 79 where personatge = 84;
UPDATE SKINS SET atac = 80 where personatge = 83;
UPDATE SKINS SET atac = 81 where personatge = 65;
UPDATE SKINS SET atac = 82 where personatge = 69;
UPDATE SKINS SET atac = 83 where personatge = 64;
UPDATE SKINS SET atac = 84 where personatge = 80;
UPDATE SKINS SET atac = 85 where personatge = 72;
UPDATE SKINS SET atac = 86 where personatge = 76;
UPDATE SKINS SET atac = 87 where personatge = 89;
*/

/*

--Updates Miquel
-- Aizen
UPDATE personatges SET 
    Classe = '�nima', 
    descripcio = N'Un geni manipulador amb un poder hipn�tic absolut, l''antic Capit� del 5� Escamot del Gotei 13. La seva Zanpakuto, Kyoka Suigetsu, controla els sentits dels seus enemics. Ambiti�s i fred, cerca trascendir els l�mits de shinigamis i d�us.',
    altura = 186, 
    pes = 74.0, 
    G�nere = 'M', 
    aniversari = '2000-05-29' 
WHERE id = 1;

-- Byakuya
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Capit� del 6� Escamot del Gotei 13 i germ� de la Rukia Kuchiki. El seu Senbonzakura es descompon en milers de fulles afilades que simulen p�tals d''un cirerer. Orgullos i elegant, sota la seva fredor, amaga un profund sentit d''honor i lleialtat.',
    altura = 180,
    pes = 64.0,
    G�nere = 'M',
    aniversari = CAST('2000-01-31' AS DATE)
WHERE id = 2;

-- Chad
UPDATE personatges
SET 
    Classe = 'Hum�',
    descripcio = N'Un hum� amic de l''Ichigo Kurosaki, que t� una for�a sobrehumana als bra�os. El seu poder prov� de la sang i el cor, protegint als seus amics sense dubtar. I encara que intimidi i sigui poc xerrador, t� un cor gegant.',
    altura = 196,
    pes = 112.0,
    G�nere = 'M',
    aniversari = CAST('2000-04-07' AS DATE)
WHERE id = 3;

-- Dondochakka
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'�s un Hollow germ� de la Nel i el Pesche, i amic de l''Ichigo, amb una m�scara peculiar i un cor innocent. La seva relaci� amb Pesche es c�mica.',
    altura = 204,
    pes = 162.0,
    G�nere = 'M',
    aniversari = CAST('2000-06-30' AS DATE)
WHERE id = 4;

--Ganju
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Un shinigami rebel i bromista, germ� de la Kukaku Shiba, i membre del propi clan Shiba, �s un expert en explosions i t�cniques. Encara que sembla poc seri�s t� un gran sentit de la justicia i la familia.',
    altura = 182,
    pes = 106.0,
    G�nere = 'M',
    aniversari = CAST('2000-10-15' AS DATE)
WHERE id = 5;

-- Gin
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'L''antic Capit� del 3er Escamot del Gotei 13, fred i enigm�tic, amb un somriure que amaga les seves veritables intencions. La seva Zanpakuto, Shinso, s''est�n a velocitat letal. Mai se sap si es amic o enemic.',
    altura = 185,
    pes = 69.0,
    G�nere = 'M',
    aniversari = CAST('2000-09-10' AS DATE)
WHERE id = 6;

-- Hitsugaya
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'El Capit� m�s Jove del Gotei 13, sent Capit� del 10� Escamot, t� un poder gelat devastador. La seva Zanpakuto, Hyorinmaru, invoca un drac de gel que congela tot al seu pas. Madur m�s enll� dels seus anys.',
    altura = 133,
    pes = 26.0,
    G�nere = 'M',
    aniversari = CAST('2000-12-20' AS DATE)
WHERE id = 7;

-- Hiyori
UPDATE personatges
SET 
    Classe = 'Visored',
    descripcio = N'Ex-shinigami rebel i membre dels Visored. Malcarada i violenta, per� lleial als seus. La seva m�scara Hollow augmenta la seva velocitat i for�a bruta.',
    altura = 133,
    pes = 26.0,
    G�nere = 'F',
    aniversari = CAST('2000-08-01' AS DATE)
WHERE id = 8;

-- Ichigo
UPDATE personatges
SET 
    Classe = 'Hum�',
    descripcio = N'Un adolescent amb habilitats de Shinigami, Hollow i Quincy alhora. La seva Zanpakuto, Zangetsu, t� un gran poder. Lluita per protegir a tothom, sense importar el perill.',
    altura = 181,
    pes = 66.0,
    G�nere = 'M',
    aniversari = CAST('2000-07-15' AS DATE)
WHERE id = 9;

-- Kenpachi
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Un guerrer nat que viu nom�s per la lluita. Sent el Capit� del 11� Escamot del Gotei 13, no t� por ni segueix una t�ctica, nom�s busca enemics forts amb qui lluitar a mort. La seva energia espiritual �s aterridora, fins i tot sense alliberar la seva Zanpakuto. Porta un pegat a l''ull que suprimeix el seu poder real. La seva �nica regla �s: "Diverteix-te en la batalla".',
    altura = 202,
    pes = 90.0,
    G�nere = 'M',
    aniversari = CAST('2000-11-19' AS DATE)
WHERE id = 12;

--  Ikkaku
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Membre de l''11� Escamot del Gotei 13 i fidel a Kenpachi. La seva Zanpakuto Hozukimaru es transforma en una llan�a destructora. Encara que sembla un lluitador brut, t� un codi d''honor irrompible.',
    altura = 182,
    pes = 76.0,
    G�nere = 'M',
    aniversari = CAST('2000-11-09' AS DATE)
WHERE id = 10;

--Ishida Uryu
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Un Quincy orgull�s i intel�ligent, expert en el tir prec�s amb arc. Rival inicial de l''Ichigo, que despr�s acaba sent un aliat clau. La seva t�cnica Letzt Stil el fa gaireb� invencible.',
    altura = 176,
    pes = 55.0,
    G�nere = 'M',
    aniversari = CAST('2000-11-06' AS DATE)
WHERE id = 11;

-- Kensei
UPDATE personatges
SET 
    Classe = 'Visored',
    descripcio = N'Capit� del 9� Escamot i ex-Visored. La seva Zanpakuto, Tachikaze, controla explosions d''aire. Un l�der dur, per� davant tot, just, que valora la for�a i la lleialtat.',
    altura = 179,
    pes = 75.0,
    G�nere = 'M',
    aniversari = CAST('2000-07-30' AS DATE)
WHERE id = 13;

-- Kira
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Tinent del 3er Escamot, melanc�lic i culpat despr�s de la tra�ci� del seu capit� i l''Aizen, troba la redempci� en la lluita. La seva Zanpakuto Wabisuke augmenta el pes dels objectius fins a esclafar-los.',
    altura = 173,
    pes = 56.0,
    G�nere = 'M',
    aniversari = CAST('2000-03-27' AS DATE)
WHERE id = 14;

-- Kira
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Un Shinigami amb aparen�a de llop gegant, i Capit� del 7� Escamot, creu fermament en la justicia i l''honor. La seva Zanpakuto Tengen Myo''o invoca un guerrer gegant que reflecteix els seus moviments.',
    altura = 288,
    pes = 301.0,
    G�nere = 'M',
    aniversari = CAST('2000-08-23' AS DATE)
WHERE id = 15;

-- Kon
UPDATE personatges
SET 
    Classe = '�nima Modificada',
    descripcio = N'Un Gikon(�nima Artificial) que substitueix al Ichigo quan assumeix la seva feina de Shinigami Substitut, i que la resta del temps est� dins un peluix amb aparen�a de lle�, t� una naturalesa pervertida, que dona peu a situacions c�miques.',
    altura = 27,
    pes = 0.182,
    G�nere = 'M',
    aniversari = CAST('2000-12-30' AS DATE)
WHERE id = 16;

-- Kyoraku
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Capit� del 1er Escamot del Gotei 13 despr�s de Yamamoto. Li agrada relaxar-se i beure sake en el temps lliure. Considera com un germ� al Ukitake. T� una Zanpakuto doble, la Katen Kyokotsu, una especialitzada en atacs r�pids i l''altre en atacs d''energia.',
    altura = 192,
    pes = 87.0,
    G�nere = 'M',
    aniversari = CAST('2000-07-11' AS DATE)
WHERE id = 18;

-- Lisa
UPDATE personatges
SET 
    Classe = 'Visored',
    descripcio = N'Ex-Shinigami i Visored, �s una pervertida obsessionada amb les revistes per adults. La seva Zanpakuto �s una guillotina gegant. R�pida i sarc�stica, per� tamb� una lluitadora formidable.',
    altura = 162,
    pes = 52.0,
    G�nere = 'F',
    aniversari = CAST('2000-02-03' AS DATE)
WHERE id = 19;

-- Mayuri
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Capit� del 12� Escamot del Gotei 13 i el m�s marginat de tots. Les seves accions son les m�s q�estionables, �s un cient�fic sense escr�pols que experimenta amb amics i enemics. La seva Zanpakuto Ashisogi Jizo injecta verins letals. Gaudir del caos �s el que m�s li agrada, i sempre porta un �s davall la m�niga.',
    altura = 174,
    pes = 54.0,
    G�nere = 'M',
    aniversari = CAST('2000-03-30' AS DATE)
WHERE id = 23;

-- Nel
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'En el seu dia port� el nombre 3 dels "Espada", ara �s una arrancar amb una personalitat infantil per� amb un poder devastador. �s amiga de l''Ichigo. Protegeix als febles amb dol�esa i for�a, encara que es passa el dia plorant pels seus amics.',
    altura = 176,
    pes = 63.0,
    G�nere = 'F',
    aniversari = CAST('2000-04-24' AS DATE)
WHERE id = 24;

-- Ulquiorra
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Fred i filos�fic, porta el nombre 4 dels "Espada", i �s un dels m�s poderosos. Creu que l''exist�ncia no t� sentit. En la seva Segona Etapa es converteix en un �sser quasi invencible.',
    altura = 169,
    pes = 55.0,
    G�nere = 'M',
    aniversari = CAST('2000-12-01' AS DATE)
WHERE id = 53;

-- Yhwach
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'El l�der del Wandenreich i pare de tots els Quincies, un d�u ambici�s que vol remodelar el m�n. Poder�s i calculador, absorbeix les �nimes dels seus seguidors per augmentar el seu poder.',
    altura = 200,
    pes = 110.0,
    G�nere = 'M',
    aniversari = CAST('2000-01-01' AS DATE)
WHERE id = 76;

-- Yoruichi
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Mestra en velocitat i arts marcials, �s l''anterior Capitana del 2on Escamot del Gotei 13, i es pot transformar en un gat negre. Elegant, enigm�tica i una de les guerreres m�s fortes de la Societat d''�nimes.',
    altura = 156,
    pes = 42.0,
    G�nere = 'F',
    aniversari = CAST('2000-01-01' AS DATE)
WHERE id = 37;

-- Orihime
UPDATE personatges
SET 
    Classe = 'Hum�',
    descripcio = N'Una noia dol�a i compassiva amb habilitats de curaci� i protecci� �niques. Els seus Shun Shun Rikka li permeten rebutjar qualsevol atac. Encara que odia la viol�ncia, lluitar� pels seus amics sense dubtar si cal, sent molt d''afecte cap a l''Ichigo.',
    altura = 157,
    pes = 45.0,
    G�nere = 'F',
    aniversari = CAST('2000-09-03' AS DATE)
WHERE id = 25;

-- Bambietta
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy capa� de convertir qualsevol objecte en una bomba. �s violenta, impacient e inestable, odia ser menyspreada pels altres.',
    altura = 156,
    pes = 49.0,
    G�nere = 'F',
    aniversari = CAST('2000-08-06' AS DATE)
WHERE id = 71;

-- Ichibe
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'El Shinigami m�s antic, i l�der de l''Escamot Zero, es capa� de controlar els noms de totes les coses, el seu poder es gaireb� div�. Es el responsable de nomenar totes les t�cniques i armes de la Societat d''�nimes.',
    altura = 181,
    pes = 105.0,
    G�nere = 'M',
    aniversari = CAST('2000-01-01' AS DATE)
WHERE id = 77;

-- Isshin
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'En el passat fou Capit� del Gotei 13, concretament del 10� Escamot, �s el pare de l''Ichigo i t� un petit Centre M�dic al Barri on viuen, es despreocupat i graci�s, per� un guerrer formidable quan cal protegir a la familia.',
    altura = 186,
    pes = 80.0,
    G�nere = 'M',
    aniversari = CAST('2000-12-10' AS DATE)
WHERE id = 85;

-- Yachiru
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'La Tinent del 11� Escamot del Gotei 13, el Kenpachi la considera com una "filla", aquesta t� un p�ssim sentit de l''orientaci�, �s amorosa i bromista amb els amics, per� aterridora en combat.',
    altura = 109,
    pes = 15.0,
    G�nere = 'F',
    aniversari = CAST('2000-02-12' AS DATE)
WHERE id = 86;

-- Halibel
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Membre dels "Espada" portant el numero 3, lidera amb serenitat i for�a, pot controlar l''aigua a un nivell devastador. Protegeix a les seves subordinades com una matriarca, mostrant el costat m�s noble dels Arrancar.',
    altura = 175,
    pes = 65.0,
    G�nere = 'F',
    aniversari = CAST('2000-07-25' AS DATE)
WHERE id = 47;

-- Wonderweiss
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Creaci� especial de l''Aizen dissenyada per contrarestar al Yamamoto. �s molt poder�s per� a canvi ha perdut la capacitat de parlar i raonar, obeint cegament les ordres de l''Aizen.',
    altura = 155,
    pes = 42.0,
    G�nere = 'M',
    aniversari = CAST('2000-07-06' AS DATE)
WHERE id = 54;

--Updates Àngel
--Askin
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Un membre del Wandenreich amb una actitud relaxada i burleta. El seu poder, "The Deathdealing", li permet manipular la dosi letal de qualsevol subst�ncia dins el cos de l''enemic, fent-lo un adversari gaireb� invulnerable si sap amb qui lluita. Encara que sembla desinteressat, �s un estratega letal que nom�s actua quan li conv�.',
    altura = 187,
    pes = 59.0,
    G�nere = 'M',
    aniversari = CAST('2000-06-06' AS DATE)
WHERE id = 63;

-- Gremmy
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Un dels Quincies m�s perillosos, capa� de materialitzar els seus pensaments. La seva imaginaci� sense l�mits �s a la seva vegada el seu major avantatge per� tamb� el seu punt feble.',
    altura = 155,
    pes = 49.0,
    G�nere = 'M',
    aniversari = CAST('2000-06-30' AS DATE)
WHERE id = 62;

-- Masaki
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Mare de l''Ichigo Kurosaki i Quincy pura. Mostra el costat m�s hum� dels Quincy, capa� d''estimar i protegir malgrat les tradicions del seu poble en respecte als Shinigami.',
    altura = 161,
    pes = 51.0,
    G�nere = 'F',
    aniversari = CAST('2000-06-09' AS DATE)
WHERE id = 65;

-- Oh - Etsu
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Membre de l''Escamot Zero, i creador de les Zanpakutos, amb un coneixement sobre les mateixes absolut, t� una personalitat exc�ntrica i li agrada rapejar a ritme de Hip Hop mentre parla.',
    altura = 172,
    pes = 62.0,
    G�nere = 'M',
    aniversari = CAST('2000-08-18' AS DATE)
WHERE id = 74;

-- Ryuken
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Pare de l''Ishida Uryu i �ltim Quincy pur. Mant� una actitud freda i pragm�tica, rebutjant les tradicions radicals del seu poble.',
    altura = 178,
    pes = 68.0,
    G�nere = 'M',
    aniversari = CAST('2000-03-14' AS DATE)
WHERE id = 82;

-- Lille
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'El primer Quincy triat per Yhwach. �s un francotirador implacable que dispara trets impossibles.',
    altura = 182,
    pes = 84.0,
    G�nere = 'M',
    aniversari = CAST('2000-04-11' AS DATE)
WHERE id = 83;

-- Shukuro
UPDATE personatges
SET 
    Classe = 'Fullbringer',
    descripcio = N'Fullbringer que manipul� el grup per benefici propi. El seu poder mostra com els m�s febles poden ser els m�s perillosos quan juguen brut.',
    altura = 198,
    pes = 73.0,
    G�nere = 'M',
    aniversari = CAST('2000-02-04' AS DATE)
WHERE id = 90;

-- Meninas
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy que posseeix una for�a f�sica descomunal. La seva aparen�a innocent contrasta amb la seva capacitat de destruir edificis amb un sol cop de puny.',
    altura = 191,
    pes = 76.0,
    G�nere = 'F',
    aniversari = CAST('2000-03-09' AS DATE)
WHERE id = 64;

-- Cang du
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy amb un poder que li permet endurir la seva pell com a metall indestructible. Un estrateg fred que prefereix esperar i analitzar abans d''actuar. Li pren el Bankai al Hitsugaya.',
    altura = 177,
    pes = 70.0,
    G�nere = 'M',
    aniversari = CAST('2000-05-27' AS DATE)
WHERE id = 66;

-- NaNaNa
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy amb una habilitat que li permet detectar i explotar els punts febles dels seus oponents. La seva actitud relaxada i observadora el fa un ca�ador pacient.',
    altura = 192,
    pes = 65.0,
    G�nere = 'M',
    aniversari = CAST('2000-02-27' AS DATE)
WHERE id = 67;

--Mask The Masculine
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy que augmenta el seu poder amb les mamballetes dels seus fans. Un personatge exc�ntric i teatral, la seva for�a creix exponencialment mentre m�s espectadors el segueixen.',
    altura = 200,
    pes = 120.0,
    G�nere = 'M',
    aniversari = CAST('2000-10-20' AS DATE)
WHERE id = 69;

-- Robert Accutrone
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy amb una habilitat similar a Lille, per� m�s enfocada en la velocitat i precisi� dels seus trets. �s un veter�, que mostra el costat m�s pragm�tic i experimentat dels soldats del Yhwach.',
    altura = 176,
    pes = 70.0,
    G�nere = 'M',
    aniversari = CAST('2000-10-04' AS DATE)
WHERE id = 72;

-- Candice Catnip
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy amb el poder de manipular els llamps a voluntat i amb una agressivitat sense igual. La seva personalitat �s explosiva i competitiva, sempre volent demostrar que �s la m�s forta.',
    altura = 166,
    pes = 57.0,
    G�nere = 'F',
    aniversari = CAST('2000-06-07' AS DATE)
WHERE id = 73;

-- Barragan
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Quincy amb un poder que li permet augmentar la for�a dels seus atacs cada vegada que mata alg�. Un assass� sense escr�pols que representa la brutalitat pura dels Quincy m�s radicals.',
    altura = 235,
    pes = 135.0,
    G�nere = 'M',
    aniversari = CAST('2000-03-25' AS DATE)
WHERE id = 91;

--Abirama
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Arrancar amb habilitats de control de vent. Les seves plomes es transformen en fulles tallants que destrossen els enemics. Un combatent arrogant que sol subestimar als seus oponents.',
    altura = 183,
    pes = 92.0,
    G�nere = 'M',
    aniversari = CAST('2000-08-19' AS DATE)
WHERE id = 41;

--Apache
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Membre de les Tres B�sties de Halibel. Ataca amb urpes afilades i una agressivitat animal. Encara que �s poc parladora, la seva pres�ncia en combat �s intimidat�ria.',
    altura = 156,
    pes = 42.0,
    G�nere = 'F',
    aniversari = CAST('2000-05-17' AS DATE)
WHERE id = 42;


--Asguiaro
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Creat pel Wandenreich, aquest combina atributs de Hollow i Quincy amb t�cniques no convencionals. Representa els horrors de l''experimentaci� descontrolada del Hueco Mundo.',
    altura = 181,
    pes = 76.0,
    G�nere = 'M',
    aniversari = CAST('2000-06-18' AS DATE)
WHERE id = 79;

-- Kirio
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio =N'Antiga Capitana del 12� Escamot, i actual integrant de l''Escamot 0, el seu menjar augmenta el poder dels aliats. T� una personalitat exc�ntrica i un coneixement profund de l''energia espiritual.',
    altura = 174,
    pes = 67.0,
    G�nere = 'F',
    aniversari = CAST('2000-12-16' AS DATE)
WHERE id = 78;

-- Chojiro
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Tinent del Yamamoto durant m�s de 1000 anys. La seva Zanpakuto Gonryomaru controla els llamps, per� sempre ha estat a l''ombra del seu Capit� sent el seu soldat m�s lleial.',
    altura = 179,
    pes = 66.0,
    G�nere = 'M',
    aniversari = CAST('2000-11-04' AS DATE)
WHERE id = 81;

-- Rojuro
UPDATE personatges
SET 
    Classe = 'Visored',
    descripcio = N'Ex-Visored i Capit� del 3er Escamot del Gotei 13. La seva Zanpakuto musical causa il�lusions auditives devastadores pels seus contrincants. Elegant i calculador, t� un estil de combat quasi coreografiat.',
    altura = 187,
    pes = 73.0,
    G�nere = 'M',
    aniversari = CAST('2000-03-17' AS DATE)
WHERE id = 87;

--Kugo Ginjo
UPDATE personatges
SET 
    Classe = 'Fullbringer',
    descripcio = N'L�der dels Fullbringers. I que anteriorment, fou el Primer Shinigami Substitut, t� l''habilitat de manipular l''�nima dels objectes, vol recuperar a tota costa el que li van prendre.',
    altura = 187,
    pes = 90.0,
    G�nere = 'M',
    aniversari = CAST('2000-11-15' AS DATE)
WHERE id = 88;

-- Jackie Tristan
UPDATE personatges
SET 
    Classe = 'Fullbringer',
    descripcio = N'Fullbringer que augmenta el poder caminant sobre superf�cies brutes. Representa la lluita dels marginats. T� un guant de metall que es carrega amb la brut�cia com a font de poder.',
    altura = 180,
    pes = 71.0,
    G�nere = 'F',
    aniversari = CAST('2000-09-05' AS DATE)
WHERE id = 89;

--Granz
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'El 8� membre dels "Espada", un geni cient�fic obsessiu. T� una habilitat que li permet analitzar i replicar les habilitats dels enemics. Un psic�pata calculador que gaudeix dissectant els seus oponents vius.',
    altura = 185,
    pes = 67.0,
    G�nere = 'M',
    aniversari = CAST('2000-06-22' AS DATE)
WHERE id = 45;

-- Loly
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Ex-Subordinada de l''Aizen que canalitza el seu odi cap a qualsevol que l''amenaci, t� un especial resentiment cap a la Orihime.',
    altura = 155,
    pes = 42.0,
    G�nere = 'F',
    aniversari = CAST('2000-01-27' AS DATE)
WHERE id = 49;

--Menos Grande
UPDATE personatges
SET 
    Classe = 'Hollow',
    descripcio = N'Es una classe de Hollow gegant que act�a amb for�a bruta. Encara que s�n limitats intel�lectualment, la seva pres�ncia massiva sumat al seu atac "Cero destructiu", el fan una amena�a per qualsevol Shinigami novell.',
    altura = 3000,
    pes = 1000.0,
    G�nere = '?',
    aniversari = NULL
WHERE id = 50;

-- Senjumaru
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Membre de l''Escamot 0, i teixidora de destins. La seva aparen�a fr�gil amaga un poder que manipula la realitat com si fos tela. Els seus estendards cerimonials s�n en realitat armes letals.',
    altura = 158,
    pes = 48.0,
    G�nere = 'F',
    aniversari = CAST('2000-11-01' AS DATE)
WHERE id = 61;

-- Kotetsu
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Tinent del 7� Escamot del Gotei 13. La seva al�ada inusual per una dona Shinigami li dona pres�ncia en camp de batalla, encara que prefereix la curaci� al combat.',
    altura = 187,
    pes = 70.0,
    G�nere = 'F',
    aniversari = CAST('2000-08-02' AS DATE)
WHERE id = 17;

-- Love
UPDATE personatges
SET 
    Classe = 'Visored',
    descripcio = N'Ex-Capit� del 7� Escamot. El seu aspecte intimidant combina amb la seva Zanpakuto de foc.',
    altura = 189,
    pes = 86.0,
    G�nere = 'M',
    aniversari = CAST('2000-10-10' AS DATE)
WHERE id = 20;

-- Mashiro
UPDATE personatges
SET 
    Classe = 'Visored',
    descripcio = N'Antiga Tinent del 9� Escamot. La seva estatura contrasta amb cops de punys devastadors sent ella, especialista en arts marcials.',
    altura = 153,
    pes = 44.0,
    G�nere = 'F',
    aniversari = CAST('2000-04-01' AS DATE)
WHERE id = 21;

-- Matsumoto
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Tinent 10� Escamot del Gotei 13, t� una relaci� c�mica amb el Hitsugaya, el seu capit�. La Hiyori sempre li retreu el seu pes, per� la seva agilitat amb la seva Zanpakuto Hianeko, demostra que les xifres enganyen.',
    altura = 172,
    pes = 57.0,
    G�nere = 'F',
    aniversari = CAST('2000-09-29' AS DATE)
WHERE id = 22;

--Updates Albert
--Ushoda
UPDATE personatges
SET 
    Classe = 'Visored',
    descripcio = N'Gegant dels Visored, es un expert en kido i barreres. Antic membre de la Divisi� del Kido, sorpr�n amb la seva delicadesa en l''artesania.',
    altura = 257,
    pes = 377.0,
    G�nere = 'M',
    aniversari = CAST('2000-09-08' AS DATE)
WHERE id = 35;

--  Lilynette
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'Mitja �nima del Coyote Starrk, amb energia inesgotable. La seva petita grand�ria li permet atacar amb rapidesa sorprenent. Porta sempre una pistola proporcionalment gran per a la seva al�ada.',
    altura = 142,
    pes = 31.0,
    G�nere = 'F',
    aniversari = CAST('2000-01-19' AS DATE)
WHERE id = 48;

-- Zommari
UPDATE personatges
SET 
    Classe = 'Arrancar',
    descripcio = N'7� membre dels "Espada" obs�s amb la "gr�cia de D�u". El seu cos esculpit mostra la perfecci� dels arrancar, i el seu poder li permet controlar els moviments amb ulls m�stics.',
    altura = 196,
    pes = 100.0,
    G�nere = 'M',
    aniversari = CAST('2000-10-13' AS DATE)
WHERE id = 56;

-- Riruka
UPDATE personatges
SET 
    Classe = 'Fullbringer',
    descripcio = N'Fullbringer que es fusiona amb nines de joguina. El seu complex d''inferioritat la porta a actuar de manera infantil. T� una obsessi� amb l''Ichigo Kurosaki.',
    altura = 156,
    pes = 43.0,
    G�nere = 'F',
    aniversari = CAST('2000-04-14' AS DATE)
WHERE id = 75;

-- Quilge
UPDATE personatges
SET 
    Classe = 'Quincy',
    descripcio = N'Inquisidor esvelt com una fulla. La seva constituci� lleugera li dona velocitat letal, el seu poder de "Jail" li permet empresonar als seus contrincants a dins una g�bia inexpugnable.',
    altura = 178,
    pes = 59.0,
    G�nere = 'M',
    aniversari = CAST('2000-09-01' AS DATE)
WHERE id = 80;

-- Tenjiro Kirinji
UPDATE personatges
SET 
    Classe = '�nima',
    descripcio = N'Membre de l''Escamot 0, tamb� anomenat "Deu de les Termes", �s la persona amb majors coneixements m�dics de la Societat d''�nimes, i fou el mestre de la Unohana.',
    altura = 193,
    pes = 88.0,
    G�nere = 'M',
    aniversari = CAST('2000-05-31' AS DATE)
WHERE id = 92;

-- Pesche
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-05-25' AS DATE),
    G�nere = 'M',
    altura = 175,
    pes = 54.0,
    descripcio = N'Un cavaller Hollow lleial i exc�ntric, company de la Nel i el Dondochakka. El seu atac "Cero Sincr�tico" �s poder�s, encara que la seva personalitat despistada el fa menyspreable als enemics ocultant la seva vertadera intel�lig�ncia per protegir als seus. S''ho passa b� fent-li bromes pesades a l''Ishida Uryu.'
WHERE id = 26;

-- Renji
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-08-31' AS DATE),
    G�nere = 'M',
    altura = 188,
    pes = 78.0,
    descripcio = N'Tinent del 6� Escamot del Gotei 13, i rival de l''Ichigo. La seva Zanpakuto, Zabimaru, �s una espassa que es transforma en una serp ossuda. Brutal en combat i de cor lleial cap al Byakuya i la Rukia.'
WHERE id = 27;

-- Rukia
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-01-14' AS DATE),
    G�nere = 'F',
    altura = 144,
    pes = 33.0,
    descripcio = N'Tinent del 13� Escamot del Gotei 13, germana del Byakuya Kuchiki i fou la Shinigami que li don� poders a l''Ichigo, tinguent una gran amistat amb aquest. La seva Zanpakuto, Sode no Shirayuki, �s una de les espasses m�s belles, capa� de congelar tot al seu pas. Elegant i seriosa, per� amb un sentit de l''humor sec.'
WHERE id = 28;

-- Soi Fon
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-02-11' AS DATE),
    G�nere = 'F',
    altura = 150,
    pes = 38.0,
    descripcio = N'Capitana del 2on Escamot del Gotei 13 i l�der dels Onmitsukido. Mant� una rivalitat amb la Yoruichi, qui fou la seva antiga capitana. La seva Zanpakuto, Suzumebachi, mata amb dos cops al mateix lloc. T� una personalitat estricta i sense paci�ncia.'
WHERE id = 30;

-- Unohana
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-04-21' AS DATE),
    G�nere = 'F',
    altura = 159,
    pes = 45.0,
    descripcio = N'Capitana del 4t Escamot del Gotei 13 i la millor curandera de tot el Seretei, amb un passat misteri�s que oculta una sed de sang. �s una persona amable i propera. La seva Zanpakuto, Minazuki, pot curar... o destruir amb sang freda.'
WHERE id = 33;

--Grimmjow
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-07-31' AS DATE),
    G�nere = 'M',
    altura = 186,
    pes = 80.0,
    descripcio = N'Un Arrancar que forma part dels "Espada", portant el n�mero 6, rival de l''Ichigo. �s un guerrer nat que desitja batalles honorables. La seva "Pantera" el fa m�s r�pid i letal. Odia perdre contra els seus contrincants.'
WHERE id = 46;

-- Yamamoto
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-01-21' AS DATE),
    G�nere = 'M',
    altura = 168,
    pes = 52.0,
    descripcio = N'Capit� General del Gotei 13 i el membre m�s vell del Seretei. Estricte i implacable, per� amb profund sentit de just�cia. La seva Zanpakuto, Ryujin Jakka, deixa nom�s cendres al seu pas.'
WHERE id = 36;

-- Ukitake
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-12-21' AS DATE),
    G�nere = 'M',
    altura = 187,
    pes = 72.0,
    descripcio = N'Capit� del 13� Escamot del Gotei 13, malalt�s per� amb un cor noble, considera al Kyoraku Shunsui com el seu germ�. Sempre actua amb compassi�, fins hi tot en els moments m�s foscos.'
WHERE id = 32;

-- Urahara
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-12-31' AS DATE),
    G�nere = 'M',
    altura = 183,
    pes = 69.0,
    descripcio = N'Antic membre del 12� Escamot del Gotei 13 i primer mestre de l''Ichigo, viu una vida tranquil�la al m�n hum� com a dependent d''una tenda de barri. Sempre est� de broma, encara que �s molt intel�ligent i mai mostra totes les seves cartes fins que �s massa tard pels enemics. La seva Zanpakuto Benihime t� t�cniques vers�tils i impredictibles.'
WHERE id = 34;

-- Yumichika
UPDATE personatges
SET 
    Classe = '�nima',
    aniversari = CAST('2000-09-19' AS DATE),
    G�nere = 'M',
    altura = 169,
    pes = 50.0,
    descripcio = N'Membre del 11� Escamot del Gotei 13 i gran amic del Ikkaku, est� obsessionat amb la bellesa fins i tot en combat. La seva Zanpakuto, Fuji Kujaku, drena l''energia espiritual dels rivals.'
WHERE id = 38;

-- Aaroniero
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-04-23' AS DATE),
    G�nere = 'M',
    altura = 205,
    pes = 91.0,
    descripcio = N'Membre dels "Espada" portant el n�mero 9. �s capa� d''absorbir habilitats d''altres Hollows, i emprar aparences d''altres. �s un monstre que disfruta amb el patiment dels altres.'
WHERE id = 40;

-- Abirama
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-08-19' AS DATE),
    G�nere = 'M',
    altura = 183,
    pes = 92.0,
    descripcio = N'Arrancar amb habilitats de control de vent. Les seves plomes es transformen en fulles tallants que destrossen els enemics. Un combatent arrogant que sol subestimar als seus oponents.'
WHERE id = 41;

-- Barragan
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-02-09' AS DATE),
    G�nere = 'M',
    altura = 166,
    pes = 90.0,
    descripcio = N'Membre dels "Espada" portant el n�mero 2, �s l''antic rei del Hueco Mundo i es pos� a les ordres de l''Aizen. El seu poder de vellesa accelerada desintegra qualsevol cosa al seu voltant. �s arrogant i cruel.'
WHERE id = 43;

--Coyote
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-01-19' AS DATE),
    G�nere = 'M',
    altura = 187,
    pes = 77.0,
    descripcio = N'Membre dels "Espada" portant el n�mero 1, un �sser tan poder�s que va dividir la seva �nima per evitar la soledat. Les seves pistoles espirituals s�n devastadores, per� prefereix evitar les lluites.'
WHERE id = 44;

--Mila
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-08-17' AS DATE),
    G�nere = 'F',
    altura = 177,
    pes = 68.0,
    descripcio =  N'L�der de les Tres B�sties de Halibel. La seva llan�a espiritual t� un abast impressionant. Lleial fins a la mort cap a la seva capitana, mostra el costat m�s noble dels Arrancar.'
WHERE id = 51;

-- Nnoitra
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-11-11' AS DATE),
    G�nere = 'M',
    altura = 215,
    pes = 93.0,
    descripcio = N'Membre dels "Espada" portant el n�mero 5. Menysprea als febles i la seva "Santa Teresa" li dona quatre bra�os. Est� obsessionat amb provar la seva superioritat.'
WHERE id = 52;

--Zommari
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-10-13' AS DATE),
    G�nere = 'M',
    altura = 196,
    pes = 100.0,
    descripcio = N'7� membre dels "Espada" obsessionat amb la "gr�cia de D�u". El seu cos esculpit mostra la perfecci� dels arrancar, i el seu poder li permet controlar els moviments amb ulls m�stics.'
WHERE id = 56;

--Bazz-B
UPDATE personatges
SET 
    Classe = 'Quincy',
    aniversari = CAST('2000-07-14' AS DATE),
    G�nere = 'M',
    altura = 179,
    pes = 69.0,
    descripcio = N'Quincy arrogant amb control sobre flames explosives. El seu poder crema fins l''�nima, i no dubtar� en lluitar per la seva pr�pia superviv�ncia.'
WHERE id = 60;

-- As Nodt
UPDATE personatges
SET 
    Classe = 'Quincy',
    aniversari = CAST('2000-12-29' AS DATE),
    G�nere = 'M',
    altura = 179,
    pes = 59.0,
    descripcio = N'Un Quincy que manipula la por, i fa que les seves v�ctimes sentin el vertader terror pur. La seva aparen�a fantasmal el fa encara m�s aterridor.'
WHERE id = 68;

-- Giselle
UPDATE personatges
SET 
    Classe = 'Quincy',
    aniversari = CAST('2000-12-24' AS DATE),
    G�nere = 'MF',
    altura = 160,
    pes = 54.0,
    descripcio = N'Quincy que pot transformar els cad�vers en zombis emprant la seva sang. �s s�dica i impredictible, i guarda un gran secret. Gaudeix convertint als seus enemics en titelles. La seva relaci� amb la Bambietta �s perturbadora.'
WHERE id = 70;

-- Jugram Haschvalt
UPDATE personatges
SET 
    Classe = 'Quincy',
    aniversari = CAST('2000-11-05' AS DATE),
    G�nere = 'M',
    altura = 189,
    pes = 80.0,
    descripcio = N'Amb una aura de misteri, �s el m�xim confident del Yhwach. El seu poder inverteix la sort, convertint la mala sort dels enemics en el seu avantatge. Un estratega fred i calculador.'
WHERE id = 84;

-- Shinji
UPDATE personatges
SET 
    Classe = 'Visored',
    aniversari = CAST('2000-05-10' AS DATE),
    G�nere = 'M',
    altura = 176,
    pes = 60.0,
    descripcio = N'L�der dels Visored i Capit� del 5� Escamot del Gotei 13, la seva Zanpakuto, Sakanade, inverteix els sentits als enemics creant el seu "M�n Invertit". La seva actitud relaxada amaga una ment estrat�gica brillant. T� un profund odi cap a l''Aizen.'
WHERE id = 29;

-- Tosen
UPDATE personatges
SET 
    Classe = 'Visored',
    aniversari = CAST('2000-11-13' AS DATE),
    G�nere = 'M',
    altura = 176,
    pes = 61.0,
    descripcio = N'Ex-Capit� del 9� Escamot del Gotei 13 que pateix ceguera i que abra�� el poder Hollow. La seva Zanpakuto t� l''habilitat de privar de tots els sentits als seus rivals. La seva trag�dia el converteix en un home obsessionat amb una just�cia distorsionada.'
WHERE id = 31;

-- Zommari
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-10-13' AS DATE),
    G�nere = 'M',
    altura = 196,
    pes = 100.0,
    descripcio = N'7� membre dels "Espada" obsessionat amb la "gr�cia de D�u". El seu cos esculpit mostra la perfecci� dels arrancar, i el seu poder li permet controlar els moviments amb ulls m�stics.'
WHERE id = 56;

--Yammy
UPDATE personatges
SET 
    Classe = 'Arrancar',
    aniversari = CAST('2000-04-03' AS DATE),
    G�nere = 'M',
    altura = 230,
    pes = 303.0,
    descripcio = N'Membre dels "Espada" portant el n�mero 10, aquest augmenta de mida i poder segons el seu nivell de r�bia. El m�s f�sic dels "Espada", per� tamb� el menys intel�ligent i impulsiu. La seva for�a bruta �s letal.'
WHERE id = 55;
*/
