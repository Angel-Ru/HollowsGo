select * from PERSONATGES order by id;

select * from ENEMICS;

select * from ATACS;

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

select * from skins;

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
*/
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