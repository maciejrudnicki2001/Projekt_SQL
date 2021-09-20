--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adddate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.adddate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
			IF NEW.date_of_joint is NULL THEN
			NEW.date_of_joint := current_date;
			END IF;
			RETURN NEW;
	END
	$$;


ALTER FUNCTION public.adddate() OWNER TO postgres;

--
-- Name: addemail(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.addemail() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
			IF NEW.email IS NULL THEN
			NEW.email := concat(NEW.czlowieki_id,'@fajna_biblioteka_2137.pl');
			END IF;
			RETURN NEW;
	END
	$$;


ALTER FUNCTION public.addemail() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id_account integer NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    czlowieki_id integer NOT NULL
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_id_account_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_account_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_account_seq OWNER TO postgres;

--
-- Name: accounts_id_account_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_account_seq OWNED BY public.accounts.id_account;


--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    author_id integer NOT NULL,
    first_name character varying(70) NOT NULL,
    middle_name character varying(50),
    last_name character varying(70)
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- Name: authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authors_author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.authors_author_id_seq OWNER TO postgres;

--
-- Name: authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authors_author_id_seq OWNED BY public.authors.author_id;


--
-- Name: book_authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_authors (
    book_id integer NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public.book_authors OWNER TO postgres;

--
-- Name: book_genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_genres (
    book_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.book_genres OWNER TO postgres;

--
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    book_id integer NOT NULL,
    title character varying(255) NOT NULL,
    total_pages integer,
    rating numeric(4,2),
    published_date date,
    isbn character varying(13)
);


ALTER TABLE public.books OWNER TO postgres;

--
-- Name: books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_book_id_seq OWNER TO postgres;

--
-- Name: books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_book_id_seq OWNED BY public.books.book_id;


--
-- Name: books_publishers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books_publishers (
    books_book_id integer NOT NULL,
    publishers_publisher_id integer NOT NULL
);


ALTER TABLE public.books_publishers OWNER TO postgres;

--
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    genre_id integer NOT NULL,
    genre character varying(255) NOT NULL,
    parent_id integer
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- Name: publishers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishers (
    publisher_id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.publishers OWNER TO postgres;

--
-- Name: booksinfo; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.booksinfo AS
 SELECT books.book_id,
    books.title,
    books.total_pages,
    books.rating,
    books.isbn,
    books.published_date,
    genres.genre,
    publishers.name
   FROM ((((public.books
     JOIN public.book_genres ON ((books.book_id = book_genres.book_id)))
     JOIN public.genres ON ((book_genres.genre_id = genres.genre_id)))
     JOIN public.books_publishers ON ((books.book_id = books_publishers.books_book_id)))
     JOIN public.publishers ON ((books_publishers.publishers_publisher_id = publishers.publisher_id)));


ALTER TABLE public.booksinfo OWNER TO postgres;

--
-- Name: borrowed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.borrowed (
    book_id integer NOT NULL,
    czlowieki_id integer NOT NULL,
    date_borrowed date NOT NULL,
    borrow_term date
);


ALTER TABLE public.borrowed OWNER TO postgres;

--
-- Name: czlowieki; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.czlowieki (
    czlowieki_id integer NOT NULL,
    name character varying(70) NOT NULL,
    surrname character varying(70) NOT NULL,
    middle_name character varying(50),
    email character varying(100),
    date_of_joint date
);


ALTER TABLE public.czlowieki OWNER TO postgres;

--
-- Name: czlowieki_czlowieki_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.czlowieki_czlowieki_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.czlowieki_czlowieki_id_seq OWNER TO postgres;

--
-- Name: czlowieki_czlowieki_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.czlowieki_czlowieki_id_seq OWNED BY public.czlowieki.czlowieki_id;


--
-- Name: czlowieki_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.czlowieki_role (
    czlowieki_czlowieki_id integer NOT NULL,
    role_id_roli integer NOT NULL
);


ALTER TABLE public.czlowieki_role OWNER TO postgres;

--
-- Name: genres_genre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genres_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genres_genre_id_seq OWNER TO postgres;

--
-- Name: genres_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genres_genre_id_seq OWNED BY public.genres.genre_id;


--
-- Name: publishers_publisher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publishers_publisher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.publishers_publisher_id_seq OWNER TO postgres;

--
-- Name: publishers_publisher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publishers_publisher_id_seq OWNED BY public.publishers.publisher_id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role character varying(63) NOT NULL,
    id_role integer NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_role_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_role_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_role_seq OWNER TO postgres;

--
-- Name: roles_id_role_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_role_seq OWNED BY public.roles.id_role;


--
-- Name: accounts id_account; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id_account SET DEFAULT nextval('public.accounts_id_account_seq'::regclass);


--
-- Name: authors author_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors ALTER COLUMN author_id SET DEFAULT nextval('public.authors_author_id_seq'::regclass);


--
-- Name: books book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN book_id SET DEFAULT nextval('public.books_book_id_seq'::regclass);


--
-- Name: czlowieki czlowieki_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.czlowieki ALTER COLUMN czlowieki_id SET DEFAULT nextval('public.czlowieki_czlowieki_id_seq'::regclass);


--
-- Name: genres genre_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres ALTER COLUMN genre_id SET DEFAULT nextval('public.genres_genre_id_seq'::regclass);


--
-- Name: publishers publisher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishers ALTER COLUMN publisher_id SET DEFAULT nextval('public.publishers_publisher_id_seq'::regclass);


--
-- Name: roles id_role; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id_role SET DEFAULT nextval('public.roles_id_role_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (id_account, login, password, czlowieki_id) FROM stdin;
1	dflagg0	nFJmZ1	1
2	rwooder1	WWNGFn	2
3	fcollacombe2	sCi1XAvqKL0O	3
4	fapperley3	oGIzklFj	4
5	ecarneck4	9ORDpkTST1	5
6	rstockton5	f10QXb	6
7	gkeysel6	1A3Zve	7
8	ogleder7	zo5gR0ZWWV	8
9	dstute8	y0waoywzl3	9
10	tbartle9	ttpInzx2E	10
11	bcramonda	f26fGu0Lh1l	11
12	lhevnerb	lmh1Hl7	12
13	mworthyc	idFUWDOd	13
14	hmcgreald	viCWtnZU	14
15	amcanee	ozlhAwzbCAY	15
16	djosskovizf	HbOXut	16
17	mtallmang	LtPin81	17
18	ccapronh	8GnfiqJ1XBq6	18
19	slillistonei	UQzS4YNClA	19
20	cweathersj	PdH5nsv1QjP	20
21	hburkek	Pb3yLOyGPymA	21
22	tgirardyl	rTUc9qJNCS	22
23	kwoollardm	FqdrcsSMwa	23
24	twildbern	rvQX1ubA1	24
25	ppapwortho	qZBLYU	25
26	abraidonp	8xrmT0W8	26
27	cpentonyq	OssPnRPz8x	27
28	jlawteyr	9VWRap	28
29	hgerrads	Zi2LZPs3B	29
30	gnorhenyt	sMduzcloo	30
31	cprestieu	1zAuMs	31
32	gmalpasv	noXmhnOI2Dz	32
33	cdymidowskiw	6VobnyB	33
34	vantonchikx	cE0v3xlsXZB	34
35	jfaldoy	4F6TCub	35
36	bmurkinz	G7q3KRWX5	36
37	tmanon10	N5F2NYKFG2	37
38	fparfitt11	RMRi1UU0	38
39	rdesimone12	Zdn7AjvxW	39
40	pbytheway13	hQEqx5O4	40
41	eleavens14	sOmyEl	41
42	trodgman15	aC5WhoM4av	42
43	dchown16	Un8n31MDwSi	43
44	jstaff17	TqQh0z	44
45	arubury18	3x9VS0Mq6f	45
46	blogg19	KxHZGrkBYs	46
47	dmalby1a	tAbhwoqG	47
48	jdionisii1b	8QxLcm	48
49	awilliscroft1c	IpDphrGkn	49
50	ekilbane1d	rQ6s0sRJA	50
51	iminghetti1e	TjgOIcRlb	51
52	rcodron1f	ed00bf4Jo3mW	52
53	mbalsom1g	v2dlke7N5Ai	53
54	sgormley1h	eOOvf5	54
55	mgrindall1i	KpEiEk8	55
56	bconnechie1j	pnoMhrl8y4e	56
57	lhogben1k	NMMocvjv	57
58	dcogle1l	eaTmCohn8P	58
59	ctarbard1m	CBxmkl0	59
60	kgrigson1n	7jHF9T7Q	60
61	etwitchings1o	xp5DTPmF0	61
62	mfrantzen1p	uK6TxX0	62
63	nebbles1q	SI2Xm3hddMT	63
64	nmcmillian1r	WXnEFaG1	64
65	dmallan1s	QIjSJOuWn	65
66	mridley1t	GWySBPTNK	66
67	strafford1u	uknkzClFkYN	67
68	wbrundrett1v	J7LGK5aOUX	68
69	clong1w	k1klCNcDbZ10	69
70	amor1x	YybW0ISD	70
71	rrudd1y	Jbm0QmuNJnmC	71
72	hbuckner1z	k0P9yjNF5ZN	72
73	csibbering20	0QxfKvu	73
74	lfinlater21	cQRMRSAyl	74
75	rchess22	KbkEhi	75
76	ashobrook23	nVr5dlTGLi	76
77	ahavik24	POf5xLU	77
78	jbroadist25	7c0eQjJx	78
79	ztowse26	PpSqmT67	79
80	cfawlkes27	V9JJ3KO7zmjE	80
81	ppiens28	EDB3rSZ2	81
82	wdunleavy29	Ne4E0e	82
83	wnorton2a	NuA07P6	83
84	zrumming2b	bxJdssCs	84
85	shumm2c	ytIuTkY	85
86	mburrell2d	v6fTif	86
87	wlerohan2e	LwDLc8N6	87
88	mvine2f	4LOYFr	88
89	edeeman2g	K4PWAei1YZ	89
90	adecaze2h	vNEf7jkCTWQP	90
91	bkitchinghan2i	ZYx8gyR	91
92	cbernardini2j	IdwCZwovSqNW	92
93	rmcgilroy2k	2WV2EwXuIwA9	93
94	nomar2l	9ZdzxATjwjx1	94
95	dossenna2m	VyjNI1O	95
96	bgitthouse2n	lOxnjVzSYgK	96
97	cdacre2o	zJUHDhx4E	97
98	fdiviney2p	jXgPAo	98
99	rparram2q	YtW67b6	99
100	rlinfoot2r	FbhMk1P4Q90	100
101	rdrakard2s	eCMZHF	101
102	icarnilian2t	nR7bE0BCK	102
103	gmonks2u	1kUkTV	103
104	eaubrey2v	YPhGXCv	104
105	joheffernan2w	2otricAJ	105
106	amedcalf2x	Tf5gcugh	106
107	mconeron2y	OtKBuOhSebe8	107
108	eridsdole2z	VyyU2U	108
109	gbridgeland30	2Y8Lkv	109
110	stumini31	NNAxsxXSgy	110
111	ajoyner32	cYhgfYDiRz	111
112	mpizzie33	LUULa1EGrdF	112
113	srouchy34	QdwbzhX	113
114	nwhiteford35	qaiYz38	114
115	abalint36	HqhYeX	115
116	wmaclaren37	C2vemy	116
117	cgress38	Xe3aGRBYFR	117
118	mrobbey39	dPorwBGc	118
119	tlaflin3a	Gmo1V06Iml	119
120	fransfield3b	zMjL8xM4	120
121	lbrisbane3c	Rdc18WzEvdmO	121
122	hkorneev3d	SF2CMnc7RbO	122
123	jpidduck3e	b0vuo4Z4Wl	123
124	scicetti3f	wUBB2V	124
125	jludovici3g	9E9DbwgP0wHo	125
126	cdelascy3h	oApLQ8CiuSA7	126
127	shalson3i	9CGZN5Y	127
128	hcuckson3j	bza35zNXxPCv	128
129	aradleigh3k	MxnMXgvgiC28	129
130	gluca3l	qirKCeto09	130
131	ldebiasio3m	3OT0Xx4	131
132	sgebhard3n	b56w6nv	132
133	gtreagust3o	MzPnkf	133
134	klynde3p	rCpmUE6	134
135	oalflatt3q	RkFpSm	135
136	omapes3r	YxL0L6wK2m	136
137	rgeorgel3s	UqBA0jMUVV	137
138	gpegler3t	wN3ami13k	138
139	capple3u	CghRXFM	139
140	bruvel3v	S8NxYXKVV5c	140
141	jhansel3w	RarA6rB4tK	141
142	whaddleton3x	rJNJIq2fX	142
143	svolkes3y	vCsoc4K	143
144	dslowcock3z	MLDyMZ	144
145	dserot40	51B4pfQB	145
146	ahandyside41	mm5sBVeX0r	146
147	wbendon42	DVgiy70	147
148	dbarniss43	gKE11qLTkOhA	148
149	gabbate44	XGNQJAb04	149
150	smarklin45	SzC5lRnbTNxz	150
151	ematushevitz46	0OL3w1oyN	151
152	fpawling47	f4w3cyWKexhg	152
153	abarczewski48	CS8ZxVWN	153
154	mrodda49	DTCcsvmZcKno	154
155	iharcase4a	5COars1yzbS	155
156	gdunkerton4b	gxDZa14yd	156
157	lmonck4c	n5rQaPu	157
158	amariner4d	Z68ppnnp	158
159	jmcrinn4e	w1XPerX8ptV	159
160	dgorgen4f	o7l8A5	160
161	dinkle4g	R8Fz80C3e0	161
162	hcopsey4h	fI9QqFzKvvsQ	162
163	pmccurlye4i	frRxhHQl	163
164	atrudgeon4j	ggXK2IAW2gI	164
165	bwalklett4k	wuClNEiAJhpr	165
166	smerrall4l	G1gDilL	166
167	nlupson4m	Wu4j7w7v	167
168	nyousef4n	ul5uAdSoxP8	168
169	vbinden4o	PJk81kZDBxPQ	169
170	acowlard4p	HvFRJol	170
171	bmacilraith4q	r3cWcPn9	171
172	ybillany4r	OcZPScTRTT	172
173	hdouble4s	DbnbxIsEOfNT	173
174	edallison4t	DLzWeT5B	174
175	kthirst4u	SVCiBS	175
176	lmanser4v	OJCQy9	176
177	stattersill4w	Mwlp1N7z	177
178	gkliesl4x	er24xDz7mQJ	178
179	dleprovost4y	FEH4cRi8	179
180	agolborn4z	rWcwGBc	180
181	nravenshaw50	M8lbIo	181
182	cbottinelli51	HmabhUJ0cN	182
183	pdorow52	fabNXynU0	183
184	ugallelli53	eR2j8bfx	184
185	ssalerg54	wNiJMOlH	185
186	nwitty55	eefMG4N4	186
187	jinglefield56	mNZUAdzrvfbu	187
188	mpeaden57	oRcjky	188
189	nborthram58	1AlVDlRbI9q	189
190	ysmaleman59	va5PIXmj9X	190
191	uuwins5a	v6pBbHvB	191
192	vdring5b	XKGZ6x7UFn	192
193	ltaill5c	MPEgCCQJ	193
194	jslocumb5d	webLUxgb	194
195	atroughton5e	b62b6c8a	195
196	vbramich5f	TqRR9Bu9y7Vs	196
197	acambden5g	7NC4m7	197
198	cduffan5h	VKQyIqR	198
199	knail5i	5d8wWqdxnlb	199
200	ashorthouse5j	9HjZBP4Pw	200
201	arice5k	ozPgyYGgDVsY	201
202	skembery5l	M8lLtdCJCKUa	202
203	acossum5m	vio6ru	203
204	mmingardi5n	w3EkZgE	204
205	rtorn5o	ddtqDC	205
206	tarckoll5p	Y4YP3BxPrp	206
207	mbehneke5q	SS0aYFRKDC	207
208	vstark5r	nlB5ufFjN	208
209	ltwiname5s	j6fZiRlB	209
210	srobson5t	AzlH1zP	210
211	byushankin5u	QalAeYlNKZ	211
212	bsterricks5v	3OYlbJE	212
213	tkunneke5w	T904g6	213
214	hertelt5x	HAGQVmQp01T6	214
215	cthouless5y	7C410R3m1v	215
216	cfuente5z	STMJTiZ	216
217	ebanstead60	lt4yZQkDL	217
218	ascutt61	wBS88ek	218
219	houghton62	h4Of8sucgDp	219
220	ebrosh63	stNYeT	220
221	njoseph64	WnIytox06	221
222	ecattrall65	qOb1YhJIG	222
223	sbamlett66	uoR9J6YjbTG	223
224	tgerrelt67	lt5TSr9S4	224
225	colivella68	zXTJMpV0e	225
226	rbadham69	5GNNnASdxYLU	226
227	jkopec6a	hRSYm7bPsUu4	227
228	cwesthoff6b	kpg3hn	228
229	elawling6c	JUhgzsUs6j	229
230	sslatter6d	LyfVBm4g	230
231	kpitcaithly6e	tzbMMaz	231
232	tshirrell6f	N18OQ2eFxDy	232
233	ktute6g	1KFopLJ6YHOk	233
234	gpeplaw6h	wreArhte	234
235	yicom6i	aVEBxfW	235
236	lpowderham6j	P6vvZCN2	236
237	ncleminshaw6k	KDy8AtbjBGx	237
238	hdenness6l	7X8nRX1cNt	238
239	egirard6m	uzS6U2	239
240	sstrudwick6n	rGXE3azm6D	240
241	daitkenhead6o	rRgW8CF	241
242	rsola6p	CdDORB	242
243	dyankin6q	gz8038C9Q	243
244	bwardroper6r	mZfdx2d	244
245	skevlin6s	EGMG2r7n9	245
246	hmallinar6t	CrJuxigG	246
247	vbalkwill6u	KPB0619	247
248	bchiese6v	Fl3GZjw6s	248
249	gash6w	VkrHmpgx	249
250	ncornhill6x	Y0u6AfCi	250
251	elaverack6y	ny4QIjJ1EEsu	251
252	dheild6z	0svc8zI	252
253	besterbrook70	kyih3CKcu	253
254	ngiovanni71	cW8ha5xyNWC	254
255	lmorales72	eXo6fv5fQ6n	255
256	csteadman73	fAsxIB6roH	256
257	tvibert74	CxoVvl5e	257
258	pridd75	ixOPz9a	258
259	certel76	TqgJFu1jpD	259
260	gjoiner77	uzl45OukLl	260
261	bsaffran78	2Gvftq	261
262	jbroadhurst79	sqcBxrGtHl1u	262
263	goveral7a	ounS9lkm	263
264	rwillimott7b	0aNnPJ1Di	264
265	yburgh7c	cbMbIb5IKq1p	265
266	rscarsbrick7d	hSL4m0jTvl	266
267	sfiridolfi7e	hVEkbrIU8l4Y	267
268	agrombridge7f	3wSuL7x3iZxH	268
269	bknoton7g	IUCEji	269
270	ktarrant7h	i2vxHLG	270
271	ckeningham7i	ffwlOrP	271
272	avigneron7j	5CCGiI6D	272
273	mscandrick7k	4rS41N	273
274	emcmickan7l	PnTHm2IwdDZ	274
275	gsheahan7m	04tXR2GWLs6	275
276	wedyson7n	62yXhElxL	276
277	gwyborn7o	DAxW2vUvu	277
278	riacavone7p	5WLrEiG	278
279	wcorssen7q	7fBHwsLB3	279
280	kthursfield7r	spxKcI3V9	280
281	lcozzi7s	zwkrth58	281
282	ahardway7t	ctHHsR0IClT	282
283	mchestney7u	6ZzjI5RV6Wm	283
284	rvondrak7v	Hk3qTVOP5Jvz	284
285	bgarron7w	ujwl8wVVMLp	285
286	kkenington7x	Utr7hHX	286
287	mbanishevitz7y	DeBAZHKctR9A	287
288	swetherick7z	r9VUf60e	288
289	bpriddey80	yNtgPpOInhov	289
290	jpowell81	av96BZCno1F	290
291	lsamper82	IRn58vLarK	291
292	pwillman83	QIW7JMzT4	292
293	eklimuk84	Qn9nJ7k2f	293
294	pnewing85	hgTprZ	294
295	rodooghaine86	15fHq70r	295
296	gmatthesius87	LoMRcWM4	296
297	flathom88	oW8CADaa0	297
298	cmonget89	nIRFjcs9	298
299	fcocklin8a	bTzGEus77s3	299
300	kdaniele8b	HeERYUYCR	300
301	jenriquez8c	bUbDxY	301
302	rlippitt8d	ZM99M22XL7	302
303	opedder8e	Io9Z3TMxR	303
304	ssainz8f	x8vUtZOeS	304
305	mbelcham8g	uCV3UPWc3m	305
306	rclyant8h	nQRmw7K2y	306
307	fglasspool8i	st2JFbx3s	307
308	fmathan8j	aytzVJSSOPt	308
309	spontain8k	J3RjrMRBn	309
310	aarghent8l	LEBw6sc	310
311	lclarricoates8m	VuHPatxA	311
312	bomailey8n	XyavlJ	312
313	nwyss8o	UgyNZnFK5iu	313
314	sbrazer8p	tIsKFIJ	314
315	dsnalom8q	mtBoVzN	315
316	rmarcone8r	EIMxur3ocNBo	316
317	oedland8s	L5VnzzPnE	317
318	bcharrisson8t	Zru1qG7	318
319	ngreet8u	cqUjnAF	319
320	ggeddis8v	w5chosxWV	320
321	jvarran8w	hMPrBE70J3a	321
322	cputtan8x	J1kRl2QkwopE	322
323	wdegiorgis8y	K2kmtXAr	323
324	ngersam8z	OVNLKNsE4	324
325	mscryne90	5DpUw8Avn	325
326	pbigglestone91	irN5RnEwj1Rl	326
327	achamley92	pr1l8mv601	327
328	jdannehl93	iWnjat	328
329	hburree94	e5E5E5didX55	329
330	mwheeler95	8qQglQB9ePr	330
331	joldford96	bGzf7ufRPsEk	331
332	kcluett97	fPiBiBOreWFz	332
333	aduplantier98	tmp4OVs1GwZw	333
334	jfroome99	S0d1FCsBCr	334
335	zchisholme9a	UGDRCSFUWp8f	335
336	rdominicacci9b	uisBGQfINy	336
337	sstroobant9c	2tIc6u	337
338	ghollingsbee9d	Dvsn6Ja6GUYG	338
339	obrabban9e	uZ1NdvsF	339
340	rklimowicz9f	PapOJPPCBu	340
341	sbramley9g	ykQCQ3Zn	341
342	fackenson9h	Zn4GArmd	342
343	hgauche9i	600Bpbkiam	343
344	zkarlik9j	0ifRN3JUoZ	344
345	clarn9k	Q9VLE3	345
346	ggammel9l	yhUarRl	346
347	whulland9m	450PQ7rgacs2	347
348	acardenas9n	ya85OIVBo	348
349	mfranceschino9o	jeUMH0	349
350	varlet9p	AxYOITQaAny	350
351	tbartoli9q	AFaxjec0h6f	351
352	apauletti9r	kMMwUS43uI	352
353	hmaylott9s	mMS3nX	353
354	cwaszkiewicz9t	uGoMF94	354
355	eswains9u	B5yoR4ohD	355
356	oosgerby9v	JYULi7zYy	356
357	hburstowe9w	ulUc8ank	357
358	ekernley9x	zIcUA6k8mN1	358
359	jblackaller9y	P03E28IWFpS	359
360	fnewsham9z	txhPy5xLb2	360
361	skeighleya0	H916LcSOo3EI	361
362	wpollicatta1	StHNkE8KdCU	362
363	koharea2	sPzlr4A	363
364	ccaultona3	AClDWXK	364
365	creynaldsa4	XViBjWULVjHa	365
366	mcroshama5	CBzseIoX	366
367	tmazzeya6	Ur4uATws	367
368	aziemena7	CLKzgf	368
369	aalesioa8	GfZPHu4qv0tH	369
370	iroadknighta9	i2DD4TdDXU	370
371	mbathersbyaa	5VjiaxBkdKe	371
372	lricketab	fhpALBCQuG	372
373	lparellac	c24JrMymp	373
374	nroddamad	p2MQlkjA	374
375	rhovendenae	rHArpzjNSDn	375
376	fdefewaf	HYzNpGwcW6Jc	376
377	llandsmanag	WpMuZ3OhI1cw	377
378	rwalbridgeah	ckKJixY0p	378
379	vlumbai	mpGcCpCRDM	379
380	ycalfaj	6JWMhLQVe9i	380
381	hblecklyak	ctA8MkPN2xY2	381
382	ddewberryal	79J1SxW7Vu	382
383	ehuddam	jRTLkBwK4	383
384	jbartoschan	baNGoXFXp	384
385	lmontacuteao	k0iXIfKgosxc	385
386	mgarmanap	UgFnuS2jO	386
387	bfrillaq	XpHLxgqxD	387
388	wgoldisar	AF0wz34a	388
389	ggowdyas	RSuW4v9Ia	389
390	cdunyat	wEh1MnEMmQ	390
391	cpoleyau	slNEEDMpYk	391
392	chaycoxav	Ejm6JpRKZQXc	392
393	acanaanaw	lUuHXup2WL	393
394	mdipietroax	iN8cDiTAl	394
395	wdagwellay	UMBWxZcn	395
396	mgillbanksaz	0o3HqYuYNg7	396
397	jmetzingb0	1jR6VzC5	397
398	adetloffb1	qnY5L5v8H7K3	398
399	mocorraneb2	k6DtxNKmA	399
400	alanktreeb3	ap71m8g1EqiG	400
401	clambdenb4	3k3EMe	401
402	aingreeb5	PaxPoVQoiYm	402
403	hduckerb6	t9jAubVzuJh4	403
404	ushorieb7	s1SuGiWGY	404
405	mtickb8	YcDuXqXNRM	405
406	bezzyb9	ZAMDSZSj1XoD	406
407	larrowsmithba	4IVSKFJoJ	407
408	apringleybb	0Xehc0W02L6	408
409	askatebc	8YsyKSCZY	409
410	cbennedsenbd	IVY0UQ6gh8	410
411	eocahillbe	2eeOe0mWz	411
412	moverstreetbf	tzp0BnFWzjuR	412
413	afostenbg	weO9vnOg4pC7	413
414	jlachaizebh	pJoJwJDCrZWs	414
415	ksallisbi	qtWbbc	415
416	epallentbj	OD3rhEvg	416
417	kbolandbk	L8KXotSAUoH0	417
418	dtetsallbl	SSHDmFWtOr	418
419	mtwiggerbm	mQOmVqMX5zNa	419
420	rwhitebn	1AZCOPGC	420
421	ggurwoodbo	E78MhTpWtk	421
422	sgrcicbp	q50vNPA1OSYQ	422
423	tritmeyerbq	GnAQ2dbr	423
424	mnicholesbr	Yu1Wm8tDNr2T	424
425	hsambellbs	QGnYYX0G	425
426	kmacclanceybt	9uYWIve0gFC	426
427	eviggersbu	rusiwrC	427
428	ccafferkybv	LOUPz5aTHn	428
429	dmadgebw	8ovmxv6	429
430	medwinsbx	8TIlZd	430
431	eseagoby	5v5XB9iDDUN	431
432	afatscherbz	BjeSOGW7zU	432
433	aspurlingc0	UU7nefjMQ	433
434	gnormansellc1	VgTmLVG4Hot	434
435	rrumgayc2	kLPnrs	435
436	djaanc3	UT3Rn8vP48k	436
437	jmesshamc4	cgwkN4bmG6mF	437
438	bkraftc5	07gkkHIub	438
439	mmoldc6	m2f8n0dcx	439
440	ccollibearc7	KlrxMmxzls6T	440
441	tmccaughranc8	stp635u	441
442	hduttonc9	ALvj4kf	442
443	abradnumca	eE4gIE	443
444	awimburycb	AEptDq8i4	444
445	gdoddemeadecc	gtlUkg	445
446	rgregorecd	NfQjsB4sxeI	446
447	rpaddockce	BXDoj58rgK	447
448	phancillcf	tU2XxiCQ5wa	448
449	dgroutcg	TiQEC6qs	449
450	mthrelfallch	dyv1wVe9efi	450
451	dsherrci	JQ8J1yswPF	451
452	ghuffeycj	9mcSDp9l54U5	452
453	bbellieck	lhChXOn	453
454	aleveecl	tbJSJLhAY	454
455	nbauercm	xdq7nrHS	455
456	hriglesfordcn	Gl6SMV	456
457	ikienlco	q1pDpBDMb	457
458	esugarmancp	yYmvnELI	458
459	fcooneycq	b9zLEIO	459
460	dsandifercr	vZZsxZVN	460
461	lbriggcs	MXGVfEk	461
462	sbassoct	BdMysqmN5	462
463	cplowmancu	gyajLg7h	463
464	jpuddlecv	oU7mdT	464
465	ncamellicw	QZSeAp	465
466	cgadiecx	XQQow9Hrf	466
467	bpobjoycy	06rUNRWRN	467
468	hsturdycz	dd0k37T6g2E	468
469	crevelled0	kvOvSagdxvGN	469
470	cbotlyd1	GWfwi4w4v	470
471	rschollingd2	CCuubP	471
472	lgettensd3	ylcRtkIrsb77	472
473	bkemberyd4	4S1ZKh0	473
474	mmaylerd5	jo1dCl	474
475	beulerd6	9uI2RFI	475
476	jhoulahand7	yXA70JXt	476
477	dpowisd8	P4HPivsD4	477
478	tsparrowhawkd9	S7p9ocXHtaE	478
479	anansomda	RNikF5h4aKu	479
480	nsambalsdb	mJ7mJH0IIeBA	480
481	kkhidrdc	bbLCo0ILhBDw	481
482	wstoatedd	RluwRA4S7f	482
483	bcumberlidgede	HuQyUA5On7	483
484	stwintermandf	4cefy2BYlv	484
485	wcrilleydg	BVl15A	485
486	awoontondh	Kfi6sYaOwzi	486
487	vrotlaufdi	aAGXkI2n0z3P	487
488	abenziesdj	cDqYxcwR	488
489	bsentinelladk	EnUEb28Nff	489
490	wgammettdl	k0GB8oe4P8DB	490
491	rshipperbottomdm	gA2n9LKqtU	491
492	efeeneydn	59HQVeYEFqam	492
493	mpalfremando	M5y9oQYN8yol	493
494	kcouttsdp	HTD4Ao2VREW	494
495	jpriterdq	k0Hda5rVp	495
496	bpusilldr	3XUmGsPvSM	496
497	tleveretds	QHiqGwS	497
498	sheddydt	Zz5ko8NkLK	498
499	dpantridgedu	nbAMkiK73KU	499
500	bespinaldv	xDPDBL3h3HbY	500
501	wmuckdw	sE2hnaSxhc1D	501
502	jjonesdx	ZQHSbIZCNB7	502
503	vshurrocksdy	t9H4Ux	503
504	baylindz	C1OZ4k	504
505	bbestere0	y2t1EyI4	505
506	sroarke1	2Ttx0mV	506
507	sistone2	M7BiD770oXBc	507
508	psieberte3	7yDRzX1pbK1	508
509	lgathwaitee4	ZYN2ETZo	509
510	jackeroyde5	1LEKGtl7qO	510
511	shylande6	4hGgwCgh	511
512	pramalhetee7	Q2psrUf4Ry	512
513	vgoddinge8	6sLlvjM8SFuB	513
514	vknutsene9	S097Il4tV	514
515	mcaghyea	CkiKgWS0T	515
516	mrayereb	1dKtUqNw	516
517	ktomainoec	s3iB57bbi	517
518	mdraysoned	nYwLpKkKhZC	518
519	amccaugheyee	pSKkG2WXLLA	519
520	cdorianef	CdgCpbpKDb	520
521	atamburieg	Kk6d09snkcm	521
522	ggierkeeh	cYaoewfr2TYa	522
523	vgrutchfieldei	Iw7i3W0RQR	523
524	mstuckej	XcHmDxrHo2H	524
525	enarramoreek	JpEvK6	525
526	cbaldreyel	23ZE4tO	526
527	gpimlockem	ADxclE3ZA	527
528	gmicheuen	d3MZEDZ	528
529	aveelerseo	AZ76h8l	529
530	amaherep	rSXNvbrjn	530
531	ghartridgeeq	ABWRYL2WO	531
532	lpitthamer	4Fo40F0fNt	532
533	bpopoves	baFS6LToYF7	533
534	ghenkeet	uahIIEHzD	534
535	bhardstaffeu	xxPMM3tut	535
536	sstephenev	Eg0eboed	536
537	tpuncherew	3nFsoU4qsn	537
538	abelshawex	hQfxQA6PcV	538
539	aseidey	KTEwolpsi5	539
540	oshearaez	Fag9o5iqCjjT	540
541	mflecknellf0	bPLXGD	541
542	jaronowf1	UX0yxa7int	542
543	pmencef2	Rx5dRKYB89h	543
544	nchisnellf3	ImWJ8Ti	544
545	tmcgrortyf4	zlcxRizxK	545
546	vgerradf5	cj4rR9WtH	546
547	mtweedlef6	4UnxzKupa5	547
548	waugustusf7	bprdMxybHp	548
549	dschoenfischf8	KFP2tx0OAA4G	549
550	cgaveyf9	lhKCYKYXF	550
551	dkilbridefa	5ezws6ol	551
552	ykiosselfb	nyuJwvkt	552
553	ahuginfc	umw0xP	553
554	mgronoufd	w5ZO2EuWsw	554
555	bdwyerfe	gQQMu0Pex	555
556	bbarringerff	On6zmBD4IZ5	556
557	mlillistonefg	4g38mo15ebTg	557
558	adeguerrefh	5FzVJFaoCYN	558
559	ehansardfi	NvjU8EuBXeF	559
560	skhotlerfj	Q66rKRA7v	560
561	lwrackfk	QTt5M2LI	561
562	cpettiwardfl	Ajus9Cdy	562
563	lkubisfm	hR82mUit	563
564	dpughefn	r71A7yDSWVU	564
565	ssayburnfo	qdCblyIjzTJ4	565
566	gdunstonefp	d9OIGNo	566
567	jmacilhargyfq	pCZFpe07ZWm	567
568	lstothertfr	hxzExCADPzBO	568
569	kbinsteadfs	LY2fuJiHct0	569
570	ilampsft	qIQHP5Jnuer	570
571	dmutlowfu	fPY38lYfUIzt	571
572	branaldfv	suc35rn	572
573	wthornberfw	jgkdZKA2hU	573
574	espraggfx	EMBFmN	574
575	mjanssonfy	viuTxEA	575
576	gtakisfz	fcCKAzhz2o27	576
577	eclowserg0	0XHuTiwEhjd	577
578	gtredgoldg1	7AfB8Vn2	578
579	jstonhardg2	CibNZx7EU4MR	579
580	cdorrg3	OSMhqD	580
581	kpring4	WtRLsHPc	581
582	vrikelg5	pU6WAi	582
583	dkieltyg6	OdADw2	583
584	snewburyg7	dgY95IW	584
585	umuldownieg8	gYGIF5WQgkI	585
586	cstoakleyg9	Hz4wkR	586
587	kguerryga	DjtdG8	587
588	bhaselwoodgb	KZfI8A6	588
589	bbruinemanngc	iLU8wZFeLvmU	589
590	smonketongd	0eQmVFr5	590
591	epeachmange	lzG6RDQtPR	591
592	hhubboldgf	5W8w9L9BBzHq	592
593	ccecigg	ksawZDMNRFR	593
594	gcorpesgh	V10phdi4IiVs	594
595	ameldrumgi	5zjJpuU	595
596	bmarmyongj	zBH6yaP	596
597	aphilippetgk	Z2ShZu	597
598	ltwiggergl	kVxLmFvf	598
599	klimprechtgm	zGVsPcjam09	599
600	agoddmangn	khpuhfAtCxK	600
601	mcaramusciago	9FAQYaey8NN	601
602	mlaurenceaugp	QcvmWAv	602
603	rrenackownagq	3amF6vu	603
604	bcalteronegr	DsmxE1reC	604
605	mcatherinegs	vnb7qdbl7U	605
606	gpristnorgt	uQyKWwxTzr	606
607	sshearstonegu	Qi1MqgS	607
608	bcaurahgv	61drnMnLz	608
609	cdoubledaygw	9grpcyXC	609
610	mbakhrushkingx	r7FPuyXbEQ	610
611	ccawleygy	oE9L3kt1djMI	611
612	fwonggz	WGtMMPmexpNd	612
613	cmauriceh0	dUBlnK8IY	613
614	uwalkingtonh1	ru7ip5Lc	614
615	churchh2	X3BXtfAgpmu	615
616	mcossonsh3	nndfOZq	616
617	jsemaineh4	32b3QMNGk	617
618	foreaganh5	bf01uHIq	618
619	bvautreyh6	CqRDPdH	619
620	mangrickh7	WQLWxagL	620
621	gverneyh8	SjsT68adGO	621
622	cphinnh9	WX1Bygn9EO	622
623	bcopcuttha	QUPlFJEX	623
624	rmertonhb	IGIe9ZunOt	624
625	mluipoldhc	7rXIG3V	625
626	gpougherhd	msrixZcLe	626
627	jleneyhe	ewiCEB5f	627
628	ttunnacliffehf	Tq2JcVSX4	628
629	ksiggenshg	094MW0OO39O2	629
630	awatsonhh	Q8I5Wzs	630
631	hpeilehi	77BNPu6	631
632	dpirdyhj	4bomo64gO0E	632
633	tcordlehk	p9dHwLm8HPqD	633
634	mgrisshl	bQPNkcAdFmQ5	634
635	bcoyhm	1xHDFxv	635
636	bboicehn	48ZTmerZJm	636
637	jbrentonho	0mnUyTOJZsdd	637
638	cannotthp	mqCRkqSY5WvJ	638
639	ffiskehq	X1RqPREi4PA9	639
640	dstallwoodhr	iqPKq3YyST	640
641	jbarliehs	G6eEUW0	641
642	fornelasht	kQvPiRrvj	642
643	kfraczekhu	JahGyDyiG	643
644	hdulakehv	2M0pFcNGHfu	644
645	hbradshawhw	05OgLrPnH	645
646	wjinkinshx	jZzrndKdp	646
647	mshoosmithhy	4GLmJ0C0uob	647
648	lhendriksehz	ppiWYDP1Xh	648
649	cswetti0	Z4gqNGA	649
650	bquartlyi1	7hJ0E0DCfyT	650
651	jjerzyki2	WGHtZOgPBN	651
652	hfeatherstoni3	stAksm7E	652
653	hwilcei4	YHZAXQ	653
654	spoluzzii5	7ojBkz5NQzK	654
655	lachrameevi6	P9kHlBLOo	655
656	bkleinsingeri7	DGRH4n55rD	656
657	fmaestroi8	07EJLFnJNRn	657
658	amurfilli9	mzsQ5tql	658
659	whiersia	cF9z6U6iPI	659
660	efissendenib	tirKsfb9Yc	660
661	dwitchardic	MNkLyIzXY	661
662	xtrusdaleid	psL0eWeK	662
663	hgrundonie	9whmZCr	663
664	gkighlyif	r6njtzIx7aO	664
665	jgherardelliig	1k4N0nbmiX	665
666	dmassonih	4928ew	666
667	asemanii	Abo4D9PlS1Yr	667
668	sbortheij	CGBUaPDI	668
669	ccayleik	IGklf0P	669
670	cwalewiczil	bAoKVtUtGfb	670
671	jelcombim	TnkQIsYYfJ	671
672	dfalkusin	ZG83D1A	672
673	lelenerio	H8f0wBY	673
674	gmcbeithip	uCntVY0TzPoF	674
675	dqualtroiq	BEHCiLp	675
676	rtoplinir	WwRllRfJ	676
677	mgomaris	UKbHKkQbsYDY	677
678	bsharmait	pqHiBb6qUTY	678
679	bprocteriu	LVnbyO3	679
680	aconichieiv	yUrYZ23BIsxY	680
681	mluckesiw	PVyzzr3zp	681
682	egavahanix	0RMz9yV	682
683	rgallandiy	PsXosu0Zm2	683
684	egerretseniz	EUuqZ9SrT	684
685	mivanyushkinj0	zl2N3d	685
686	omickleburghj1	qXWeVdNnkE	686
687	gletrangej2	XmiNiOzduhsJ	687
688	koliveyj3	uFbpHb8	688
689	msanpherj4	wqAnjiTpFL	689
690	kwidgerj5	9etDgg5aqq	690
691	ccriellyj6	ygBzFoiZr	691
692	cspellsworthj7	rw8wkqMFRt	692
693	dtreugej8	G9HfzQzQ	693
694	cjuleffj9	j48Hx51Sw1V6	694
695	blivardja	t12bxIzC8LF	695
696	yjayumejb	kNqxSLVCh2	696
697	achildejc	RUah97IUieq	697
698	poenjd	zGBWdRTa	698
699	lfallowsje	VpHiaiu	699
700	lseniourjf	Dm02rQO	700
701	fhinnerkjg	3uO1Vm	701
702	adelguajh	BRB1vM	702
703	hheninghemji	8FVxOI	703
704	arosternjj	m8F4AfWPk	704
705	hbuskjk	S3wNFy	705
706	rrattjl	H1U9AJJTKt8E	706
707	battwoulljm	7FfcWTkhwb	707
708	mshapcottjn	TdXIRJ	708
709	cjothamjo	DSuP56VQdo	709
710	jbakhrushinjp	nXs6Ob	710
711	afiddlerjq	wzE9BeN	711
712	gwhitemanjr	fM6oJA	712
713	fmardlejs	BwzwDzVCyR5	713
714	rteasdalejt	RgJ19nKwuB	714
715	lhuikerbyju	hDLRxbUF2ku	715
716	jsaphjv	IOUukrOuc	716
717	cmacgowingjw	c65LRKWyx	717
718	mpoultneyjx	DaoFpjzHBXv	718
719	blanghornjy	qPYBjBnzvAh	719
720	hdumbartonjz	bCkGay	720
721	nbrionk0	B6tNfCRME	721
722	lcarissk1	2YljXu	722
723	glatchk2	ED9SX52khvr	723
724	lmuirdenk3	prosD5ybhh	724
725	rriglesfordk4	DsAgNv6N7F6	725
726	eodoireidhk5	MkFS4g	726
727	lpalmbyk6	NOTAvRLpffFV	727
728	gcutajark7	9wQ2zd64	728
729	abraddickk8	inIKyAlEyw	729
730	lphythonk9	sYUV2PmYrN	730
731	mkitchinghanka	gXDIvtJPYN2B	731
732	khubbertkb	r6T2wG	732
733	wpienskc	PxKBhAR1	733
734	tdurrantkd	2M4Qc20qQGfh	734
735	lstrawke	ienYaS3bDCa3	735
736	hcallamkf	niiYAqHbX08	736
737	rpaskerfulkg	4Gs49m	737
738	epirozzikh	G1o7NYuTb	738
739	amorrottki	jcpubV2jzLqx	739
740	jdoretkj	4AYWwWxCwa	740
741	ctargekk	MBXoMEISP	741
742	uerteltkl	PFwe2UrcY	742
743	jlodewickkm	wjc1vahJzmR	743
744	lmckechniekn	JaZ9yjVdeC	744
745	pgoudako	4j1I2SwvpJA	745
746	rchaferkp	cEeIJy0Q2	746
747	jcrinionkq	1Pldh1	747
748	lelgerkr	8iTD8PuYGh	748
749	khalcroks	k0PSMG	749
750	etremethackkt	wgMQg7v78ne	750
751	kbrigstockku	fmaBn877RPZc	751
752	ckeffordkv	Da6cUb	752
753	aadanezkw	qW0gi5	753
754	sgaudenkx	LfqVgY	754
755	ogranhamky	EbiiR6uRJPUy	755
756	mmackibbonkz	KdqCLgm3Eag	756
757	mteanbyl0	rgRHJgNx	757
758	jbrockiel1	mMUmBaDT0mbf	758
759	sbickfordl2	MpSQp1LC	759
760	rringhaml3	CpAjGJ1AQ	760
761	widelll4	5LPzSJwCL	761
762	btryl5	PR1czwA0mW	762
763	fmclaughlinl6	4EAtIxKSvAGh	763
764	cmyttonl7	YwN4PgjBZ24z	764
765	sgianiellol8	hsWWNDTMEmnE	765
766	elibbisl9	kBB55ZVX1Bw	766
767	dsilvertonla	FkWMkyyTXob	767
768	dgatuslb	thZMSB9d	768
769	ulanfearlc	s0O98EC	769
770	mygold	2SHIyvZP7Jf	770
771	ecoslettle	41Z0m8imt	771
772	lpacklf	kFIvnlNG	772
773	mfladgatelg	SKf0Hc35	773
774	tsterlandlh	h1ZtCJ7	774
775	vnegalli	BDapnheqPi	775
776	eballstonlj	VE5Y4wy0r	776
777	nworrallk	rB6o8A6lE4Y	777
778	weakenll	vcRsCCJOozo	778
779	gstuddertlm	vD1AZwWS	779
780	mravenhillsln	lncfZJuE	780
781	rodhamslo	UNi2KBF	781
782	ldavleylp	Q8rulbak2lZ	782
783	dcoetzeelq	0Icdfr	783
784	jjarmainelr	4MeYq3NJPh	784
785	ekemerls	ic8pdXzBd	785
786	acrampseylt	seFUqNUJw	786
787	aiacovideslu	z58hAxMj7	787
788	sflamanklv	egcz5CNFk	788
789	bilyinykhlw	gjOzygY	789
790	iwillerstonelx	AcsKJ6t1qCm	790
791	ggoschalkly	lIiE6d4D6wj	791
792	jeversonlz	Zc1WlIXZ4g	792
793	jrichfieldm0	4v61SGGvyVWK	793
794	daspelm1	NQAUNPiINSHR	794
795	kreedsm2	jTSuIH	795
796	cmacparlanm3	wsAWPLxrT	796
797	jorganm4	UHmt3xBINnv	797
798	fmaldenm5	S0bMt0HoS	798
799	mewingm6	caxuSYNkMHIf	799
800	dleaheym7	svqbPEzs30	800
801	avanderkruism8	1rDTYKva	801
802	rstubbesm9	x9lbK3BWZ	802
803	mcreanema	yjPYn8C	803
804	mrowlsonmb	8pN01Mm0	804
805	dticklemc	J4R2RudRV2Z	805
806	ncanadasmd	qEkjd5n8n	806
807	cwhiskerme	X4xw7jK3yLHc	807
808	poxbymf	a8sboXV	808
809	cdegouymg	kccRqFC8PB8K	809
810	fnobletmh	rerjLN5Nb6El	810
811	yreaganmi	ACJdGil	811
812	oprovenmj	XAk1Ayk4I	812
813	gnutleymk	Zx0eCjrhogPb	813
814	fcreechml	grLdzEg3	814
815	rmcallastermm	vzFYmU4V8Z	815
816	bmechanmn	S4FurK	816
817	eantoniuttimo	XIjNhrW	817
818	bmaccaughanmp	kd7Lzcqo	818
819	fabdenmq	PEgQ4Eqk	819
820	mserridgemr	Zvr7DW38Is	820
821	bcartmillms	LmwdVgMZHw	821
822	eloudermt	a3pyEMMKY	822
823	jjosefsenmu	0VvTitGYk98O	823
824	mtiuitmv	epoH55o8sexb	824
825	lkeddeymw	kLzYjRn2h	825
826	fguenymx	ycLGCSsQb4	826
827	lboatswainmy	CpdpPHBSho	827
828	cbeigmz	uq1uvy0c	828
829	dscorahn0	EXCNyUJN8	829
830	ochessiln1	DLyJS3mxKCO	830
831	lgutchn2	n0MeOEoh2aJ	831
832	hgirardinin3	1TO5qm	832
833	rbrymhamn4	w3vh5N6DyYN	833
834	amewisn5	kA242wlXE6	834
835	mmenloen6	FYDNzsXQX	835
836	espracklingn7	ZlMNeFQe	836
837	dbaynhamn8	B2A59Zv5L	837
838	gmcnelisn9	4XWDGXwQ9m	838
839	ebuttrickna	HFiJxF9y	839
840	rdownb	7XyEezPkXJ	840
841	pkeplingnc	GwiljRzbPJT	841
842	knavannd	MAzwcFG	842
843	zhelstripne	ctYoLb	843
844	tgluyasnf	iZpFfDnD9	844
845	lscottining	1N7nY6j	845
846	eidanh	CtFVpo	846
847	nbateupni	DnkpYju	847
848	ewoodheadnj	sz2vCuUhCy6E	848
849	alambkinnk	4Wox1GgtdRhG	849
850	estrydenl	9bwZAz	850
851	tlegisternm	gqonZS	851
852	aculbardnn	hOmyVpR9s5	852
853	dfortno	hbeXcZ1Wsi7A	853
854	cizkovicinp	AFOfs5z	854
855	twilnenq	HWsSMGKDf	855
856	ividelernr	gQ1259vtb	856
857	cguntripns	lNwp6E4q0xwo	857
858	cmounceynt	2mJ9z8gr0QRD	858
859	kbarhemnu	oAc8bZwK1As	859
860	medwinsonnv	13tb4OMl	860
861	lroothamnw	PPAwtK	861
862	shalgarthnx	Bvj3b9eym	862
863	kbeadlesny	hMEgYaR1Bd4A	863
864	tklezmskinz	iCB6jMEMn	864
865	bstileo0	zu62BHR7Lf	865
866	dbarkeo1	5dk3Y9F2F	866
867	ghughmano2	WN59v9	867
868	fbarkaso3	vUNleSAo	868
869	drawsthorno4	gJYHM1	869
870	echampneyso5	jeYYXimP	870
871	rliptrodo6	Xly3o8DMqyS	871
872	ascuttero7	rF9zPV1eIma	872
873	ewyreo8	ynwoCRAUuHJU	873
874	sdimmocko9	vfVbcp	874
875	jnijsoa	wpaRG9KQ6m69	875
876	pandriveauob	rgbowQ	876
877	bmarkwelloc	CTYcNCzUxVC	877
878	chowsleyod	9LJkwuSBy3	878
879	tkmietschoe	ogv5Jgy	879
880	smcrobbieof	1otEOu	880
881	nrandersonog	UIOO9Ip	881
882	ffronczakoh	yQHvfBOGLoqZ	882
883	crosseroi	htA698CShd	883
884	emacfauloj	hKthchAyXs	884
885	measdonok	P0EqP8sWcASM	885
886	hwedgwoodol	8nHkCqlVjOmC	886
887	cbryettom	s06oNhnJrAK	887
888	lpynneron	AUqBD0mIN	888
889	mjoscelinoo	GDggjfyX	889
890	ndulinop	333fqPk	890
891	kwhitnalloq	E0L6cCGxNJD2	891
892	mmacelhargeor	ssPzlHJA	892
893	bfawbertos	wZIbJ0j	893
894	ctettherot	wJuE0QTc	894
895	adowneyou	6IqGusUhL	895
896	ustrikeov	5ioFMzI9txia	896
897	oritterow	68MU3J7	897
898	achilversox	mOQgio	898
899	odaudoy	SAF9bG5lIQZV	899
900	ufillimoreoz	Q80kQxJzXG	900
901	nturveyp0	MQAf2X5	901
902	rgaukrogerp1	CnqO4YIPVkw	902
903	jeppp2	Em4fSTs	903
904	rwhittakerp3	APoSqu	904
905	qpindellp4	7ikDoTAV	905
906	sspindlerp5	KOBZC2G2ObxM	906
907	dburkerp6	R3IPTf	907
908	sdewarep7	I3nxAxJz6	908
909	lbarrowp8	Y6S9sQ62ei	909
910	rpaulsonp9	NlUEOQJREd	910
911	hbulledpa	NzyjHiko	911
912	taldwickpb	MRfYafxOI0	912
913	mtanzerpc	dirGFU	913
914	gmerdewpd	G4F3SnVFFaQ	914
915	rkemerpe	fCvSYa	915
916	cbulloughpf	uL12FyxB	916
917	mkonigpg	fu2qc7	917
918	eogbourneph	9UseYp	918
919	cminuccipi	QPDo8TzI5wT	919
920	amcblainpj	mjxwBt9gUBY4	920
921	gcivitillopk	40KLBT	921
922	ggronouspl	CGrEB4A2AZ	922
923	pkellockpm	gjx4X1Dv	923
924	bdellopn	iUy61O	924
925	wfishbournepo	2GMEoIYTElLH	925
926	oheaysmanpp	p8juhBO	926
927	schiplinpq	kFefoZAhL00	927
928	gguthriepr	KQbTZAh	928
929	dwaldrenps	OdiN3hMM7bl	929
930	acreept	o83qtO	930
931	lmeharrypu	mQQv9sNeNdlb	931
932	jhaslockpv	VCsHq0	932
933	rvasilischevpw	6JCvATCQ	933
934	jerwinpx	VkxzMwIOTo1	934
935	sduncanpy	vqYL04r	935
936	spresshaughpz	24AecGp5D	936
937	anuschaq0	XaJEgZbHz	937
938	nabaroughq1	sZu4O11PV	938
939	nsealsq2	JTd5SQhO	939
940	jgrinawayq3	z13h8f	940
941	vcressorq4	eME2aA	941
942	htheobaldsq5	CVeLCVcDb	942
943	ptrailq6	g9mJULRYsC	943
944	kghelardiq7	66EfcR	944
945	iorvissq8	OP1p4eU92Fi	945
946	edykeq9	il6ny9z	946
947	bvelasquezqa	7Qmd28	947
948	srobbekeqb	rmhNDQ	948
949	ltanfieldqc	Q7cf5VIfP	949
950	ewenbanqd	sREltZCA9ZH	950
951	emcclementsqe	leKWxsNXJ	951
952	ipettingillqf	YO8tHSCkb	952
953	mnorganqg	SitmJtmN92k	953
954	kcuttingqh	WH1Z1n	954
955	slibreyqi	zkC4PokM9k	955
956	dgouldbournqj	Cd2zCJ4DV	956
957	dsansomeqk	4qNKttfwYsV	957
958	afidellql	lZH85yg	958
959	awinterbourneqm	PK3ZO1W	959
960	rgraveyqn	4TvXTE77W	960
961	fsylettqo	unpQaJH	961
962	pschultheissqp	sWO0Z9pN9liy	962
963	osvaniniqq	Sl5H2Hz	963
964	flepardqr	jUXzVXFyng	964
965	dfarquharqs	EnA8qYr	965
966	clewardqt	fRhQ2p	966
967	shiblingqu	Ww2hKjXn	967
968	jcazaletqv	al2fhvO7	968
969	jattrieqw	UQicQlE	969
970	vdebrokeqx	wseqt9J	970
971	jschumacherqy	RUCkSdj	971
972	agloucesterqz	TwMzM4blJ	972
973	fdwelleyr0	eojIvQFJ	973
974	rpeerr1	ghSlgJBGe7	974
975	hohartaganr2	CSCAwo5roDC	975
976	cdottridger3	RMNUpD9H	976
977	btrevettr4	4CmK4W1OL5EP	977
978	gcorbynr5	YU68QD1E4TsR	978
979	dchrystier6	lYHOciSxx0XQ	979
980	faberkirderr7	eGbPaO	980
981	tdismorer8	ic5W9AGxnX	981
982	trobensr9	e0MPIEdRon	982
983	bchorleyra	bj3Sr03	983
984	eworsnaprb	2fNAOT9kIQO	984
985	lmaniloverc	7sDJHPLr6	985
986	sjorckerd	AHbtog1	986
987	epettegreere	pqGGUfK5CehM	987
988	aphilipsohnrf	UXEPtg4	988
989	kkeightleyrg	1QNOLSH	989
990	dboigrh	4EqzO7sx	990
991	cpolkinhornri	ciWVUsrDvpUQ	991
992	ccoplestonerj	grOt41lyG1ih	992
993	gsummerskillrk	A5CPz6y42	993
994	gemblowrl	L2217tyElPK	994
995	bzecchiirm	KScrv04ZKx	995
996	hlaffordrn	GXrkw3fdv4D	996
997	wpreedyro	wrY2dPPbuP	997
998	rleonidarp	tSBLLm3txSXK	998
999	ahallattrq	cuIsPQLGnhP	999
1000	lmaniloverr	RgKPJkie4Tek	1000
\.


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (author_id, first_name, middle_name, last_name) FROM stdin;
1	Merritt	\N	Eric
2	Linda	\N	Mui
3	Alecos	\N	Papadatos
4	Paul	C.van	Oorschot
5	David	\N	Cronin
6	Richard	\N	Blum
7	Yuval	Noah	Harari
8	Paul	\N	Albitz
9	David	\N	Beazley
10	John	Paul	Shen
11	Andrew	\N	Miller
12	Melanie	\N	Swan
13	Neal	\N	Ford
14	Nir	\N	Shavit
15	Tim	\N	Kindberg
16	Mike	\N	McQuaid
17	Brian	P.	Hogan
18	Jean-Philippe	\N	Aumasson
19	Lance	\N	Fortnow
20	Richard	C.	Jeffrey
21	William	L.	Simon
22	Magnus	Lie	Hetland
23	Mike	\N	McShaffry
24	Norman	\N	Matloff
25	John	E.	Hopcroft
26	S.	\N	Sudarshan
27	Bruce	\N	Eckel
28	Bill	\N	Gates
29	Shane	\N	Harvie
30	Ralph	P.	Grimaldi
31	Garry	\N	Kasparov
32	Lawrence	C.	Paulson
33	Donella	H.	Meadows
34	Maria	\N	Levitin
35	Joy	A.	Thomas
36	Scott	\N	Rosenberg
37	Mark	\N	Nelson
38	Hal	\N	Abelson
39	Ray	\N	Seyfarth
40	Fred	\N	Turner
41	Andrew	\N	Honig
42	Helen	\N	Sharp
43	Katie	\N	Hafner
44	Christopher	\N	Negus
45	Ralph	\N	Kimball
46	Trent	R.	Hein
47	Venkat	\N	Subramaniam
48	Simon	J.D.	Prince
50	Stephen	\N	Wolfram
51	Jennifer	\N	Petoff
52	Massimo	\N	Banzi
53	Mickey	\N	Petersen
54	Ethem	\N	Alpaydin
55	Ytaelena	\N	LA3pez
56	John	L.	Hennessy
57	Cameron	\N	Moll
58	Jamie	\N	Levy
59	Janet	\N	Gregory
60	Jenifer	\N	Tidwell
61	Steven	S.	Skiena
62	Jimmy	\N	Soni
63	Tracy	\N	Kidder
64	Douglas	R.	Hofstadter
65	Zed	\N	Shaw
66	Yoav	\N	Shoham
67	Danny	\N	Goodman
68	Bert	\N	Bates
69	David	\N	Gries
70	Eric	\N	Newcomer
71	Jim	R.	Wilson
72	Maarten	van	Steen
73	Tsung-Hsien	\N	Lee
74	M.	Mitchell	Waldrop
75	George	\N	Pólya
76	Richard	S.	Bird
77	Ben	\N	Collins-Sussman
78	Micha	\N	Gorelick
79	Christopher	T.	Haynes
80	Carlos	\N	Bueno
81	Michael	L.	Scott
82	William	Jr.	Gwaltney
83	Binu	\N	John
84	Dan	\N	Bader
85	Chris	\N	Smith
86	Andrew	\N	Stellman
87	Kevin	\N	Poulsen
88	Peter	\N	Linz
89	Jim	\N	OGorman
90	Ali	\N	Almossawi
91	David	\N	Robson
92	Brad	\N	Abrams
93	Timothy	\N	Downs
94	Kyle	\N	Loudon
95	Robert	\N	Eckstein
96	Wolfgang	\N	Banzhaf
97	Mike	\N	Beedle
98	Luke	\N	Ruth
99	Brad	\N	Stone
100	David	\N	Gourley
101	Greg	\N	Kroah-Hartman
102	Jurgen	\N	Appelo
103	Eric	\N	Ries
104	Ian	\N	Parberry
105	Johan	\N	Vromans
106	Corey	\N	Sandler
107	Devon	\N	Kearns
108	Steven	\N	Feiner
109	Kevlin	\N	Henney
110	Abraham	\N	Silberschatz
111	Mark	\N	Russinovich
112	Carl	\N	Eastlund
113	Hans	\N	Langtangen
114	Carin	\N	Meier
115	Rebecca	\N	Wirfs-Brock
116	Lasse	\N	Koskela
117	David	\N	Chelimsky
118	Why	Stiff	Lucky
119	Christopher	\N	Hadnagy
120	Sebastian	\N	Raschka
121	Henk	\N	Barendregt
122	Tobias	\N	Nipkow
123	Chris	\N	Bernhardt
124	Joost-Pieter	\N	Katoen
125	R.G.	\N	Dromey
126	Andrew	\N	McAfee
127	Jeff	\N	Hawkins
128	Paul	\N	Deitel
129	Albert	\N	Meyer
130	Angus	\N	Croll
131	Jason	\N	Hickey
132	Nathan	\N	Marz
133	Miguel	\N	Revilla
134	Maurice	\N	Herlihy
135	Gareth	\N	James
136	Hanne	\N	Nielson
137	Vern	\N	Ceder
138	Matt	\N	Pharr
139	Joe	\N	Armstrong
140	Mati	\N	Aharoni
141	Patrick	\N	Debois
142	Sandi	\N	Metz
143	Benedikt	\N	GroAY
144	Peter	\N	Sanders
145	Baron	\N	Schwartz
146	Paul	\N	Clements
147	Scott	\N	Ambler
148	R.	\N	Dybvig
149	Stephen	\N	Figgins
150	Stephan	\N	Mertens
151	Cay	\N	Horstmann
152	Luis	\N	Atencio
153	Michael	\N	Nielsen
154	Aaron	\N	Courville
155	W.H.	\N	Feijen
156	Richard	\N	Bejtlich
157	Peter	\N	Bruce
158	Adam	\N	Gibson
159	Vernon	\N	Ceder
160	Patrick	\N	Winston
161	Scott	\N	Vanstone
162	Jon	\N	Duckett
163	Nick	\N	Bostrom
164	Michael	\N	Dahlin
165	Eric	\N	Meyer
166	David	\N	Harel
167	Claude	\N	Shannon
168	Daryl	\N	Harms
169	Dan	\N	North
170	Roberto	\N	Tamassia
171	Paul	\N	Freiberger
172	George	\N	Heineman
173	Jeffrey	\N	Yost
174	Matt	\N	Weisfeld
175	Luciano	\N	Ramalho
176	Mary	\N	Poppendieck
177	M.	\N	Ozsu
178	Emily	\N	Chang
179	Douglas	\N	Stinson
180	Sara	\N	Wachter-Boettcher
181	Rajeev	\N	Motwani
182	John	\N	Sonmez
183	Y.	\N	Liang
184	Stanley	\N	Selkow
185	Christopher	\N	Duncan
186	Michael	\N	Whitman
187	Ron	\N	Jeffries
188	Johannes	\N	Braams
189	SaA!a	\N	Juric
190	Peter	\N	Thiel
191	Steve	\N	Souders
192	Jerome	\N	Friedman
193	Scott	\N	Mueller
194	Mark	\N	Dowd
195	Kelli	\N	Houston
196	Hinrich	\N	Schütze
197	Ethan	\N	Marcotte
198	Mark	\N	Pilgrim
199	Martin	\N	Davis
200	Craig	\N	Sharkie
201	Addy	\N	Osmani
202	N.	\N	Friedman
203	Daniel	\N	Rose
204	Chris	\N	Houser
205	Linus	\N	Torvalds
206	Matthew	\N	Helmke
207	John	\N	Battelle
208	Jon	\N	Kleinberg
209	Alan	\N	Cooper
210	Yoshua	\N	Bengio
211	Henrik	\N	Kniberg
212	Anshul	\N	Gupta
213	Judith	\N	Gersting
214	Jared	\N	Spool
215	William	\N	Brown
216	Ward	\N	Cunningham
217	Wladston	\N	Filho
218	Johnny	\N	Long
219	Cathy	\N	ONeil
220	June	\N	Barrow-Green
221	Jason	\N	Williams
222	Edward	\N	Skoudis
223	Jérémie	\N	Zimmermann
224	Mario	\N	Fusco
225	Jason	\N	Gregory
226	Micah	\N	Martin
227	Lloyd	\N	Trefethen
228	Erwin	\N	Schrödinger
229	Chris	\N	Dannen
230	Shlomo	\N	Angel
231	Tom	\N	Badgett
232	Shon	\N	Harris
233	Brian	\N	Krebs
234	Graham	\N	Hutton
235	Ross	\N	Anderson
236	Linda	\N	Torczon
237	Steve	\N	Freeman
238	Simson	\N	Garfinkel
239	Ilya	\N	Grigorik
240	Jan	\N	Eijck
241	Philip	\N	Bernstein
242	Larry	\N	Ullman
243	Michael	\N	Feathers
244	Linda	\N	\N
245	Martin	\N	Ford
246	Sandro	\N	Mancuso
248	Donald	\N	Rubin
249	Steve	\N	Matyas
250	Richard	\N	Woods
251	Tim	\N	Roughgarden
252	Jeff	\N	Edmonds
253	Eoin	\N	Woods
254	Brian	\N	Fitzpatrick
255	N.	\N	Mermin
256	Karl	\N	Seguin
257	Leo	\N	Brodie
258	Robert	\N	Sebesta
259	Janet	\N	Valade
260	Bill	\N	Fenner
261	Lorna	\N	Mitchell
262	Satya	\N	Nadella
263	Dan	\N	Cederholm
264	Bryan	\N	Helmkamp
265	Dale	\N	Dougherty
266	Ka	\N	Cheung
267	Mark	\N	Lutz
268	Tom	\N	Phoenix
269	Mark	\N	Hamstra
270	Gayle	\N	McDowell
271	Michael	\N	Swaine
272	Yvonne	\N	Rogers
273	Edmond	\N	Lau
274	Mike	\N	Clark
275	Gordon	\N	Blair
276	Mark	\N	Ciampa
277	Pramod	\N	Sadalage
278	Subrata	\N	Dasgupta
279	Stuart	\N	McClure
280	Gary	\N	Bradski
281	Brian	\N	Lonsdorf
282	Jesse	\N	Robbins
283	Steven	\N	Pinker
284	David	\N	Stork
285	Luke	\N	Wroblewski
286	Graham	\N	Lee
287	J.	\N	Adams
288	Stephen	\N	Thorne
289	Dmitry	\N	Jemerov
290	Thomas	\N	Connolly
291	J.	\N	Brookshear
292	W.	\N	Hillis
293	Petar	\N	Tahchiev
294	Arnold	\N	Robbins
295	Chris	\N	Hankin
296	Jack	\N	Moffett
297	Andreas	\N	Wittig
298	Kjell	\N	Johnson
299	Christine	\N	Bresnahan
300	Tom	\N	Christiansen
301	Harvey	\N	Deitel
302	Allan	\N	Friedman
303	Tom	\N	DeMarco
304	Chris	\N	Rowley
305	Chris	\N	Eagle
306	Gina	\N	Smith
307	David	\N	LeBlanc
308	Andrea	\N	Arpaci-Dusseau
309	Martin	\N	Reddy
310	Eliezer	\N	Yudkowsky
311	Alfred	\N	Aho
312	John	\N	Maeda
313	Janna	\N	Levin
314	Christopher	\N	Cunningham
315	Flemming	\N	Nielson
316	Anne	\N	Troelstra
317	Hartley	\N	Rogers
318	Jonathan	\N	Katz
319	Cory	\N	Althoff
320	Betty	\N	Toole
321	H.	\N	Schwichtenberg
322	Sara	\N	Ishikawa
323	Dennis	\N	Shasha
324	Daniela	\N	Witten
325	Nilanjan	\N	Raychaudhuri
326	Avdi	\N	Grimm
327	Martin	\N	Fowler
328	Brian	\N	Carper
329	Mat	\N	Buckland
330	Amit	\N	Prakash
331	V.	\N	Spraul
332	Craig	\N	Martell
333	Svetlana	\N	Isakova
334	James	\N	Trott
335	Kenneth	\N	Rubin
336	William	Jr.	Shotts
337	Ian	\N	Sommerville
338	Dennis	\N	Ritchie
339	Brendan	\N	Burns
340	Adele	\N	Goldberg
341	Conor	\N	McBride
342	Andy	\N	Müller-Maguhn
343	Foster	\N	Provost
344	Tom	\N	Mitchell
345	Duncan	\N	Watts
346	David	\N	Wood
347	Ming	\N	Li
348	Alan	\N	McKean
349	Tatiana	\N	Diaz
350	David	\N	III
351	Nelson	\N	Beebe
352	Mike	\N	Meyers
353	Bruce	\N	MacLennan
354	Suzanne	\N	Robertson
355	David	\N	Carlisle
356	Peter	\N	Weinberger
357	Ingrid	\N	Fiksdahl-King
358	Igal	\N	Tabachnik
359	Greg	\N	Michaelson
360	Jeroen	\N	Janssens
361	Nicholas	\N	Haemel
362	Felix	\N	Halim
363	David	\N	Kennedy
364	Roger	\N	Pressman
365	J.P.	\N	Vossen
366	Daniel	\N	Higginbotham
367	Colin	\N	Evans
368	Robert	\N	Nystrom
369	Ron	\N	White
370	Justin	\N	Schuh
371	Carlos	\N	Coronel
372	Matt	\N	Carter
373	Guy	\N	Theraulaz
374	Zachary	\N	Tong
375	Richard	\N	Stallman
376	David	\N	Holmes
377	George	\N	Dyson
378	Kent	\N	Beck
379	Nathan	\N	Ensmenger
380	Micah	\N	Alpern
381	Steven	\N	Halim
382	Greg	\N	Riccardi
383	Matthew	\N	Lyon
384	Dan	\N	Jurafsky
385	Asanovi	\N	\N
386	Richard	\N	Gabriel
387	Marco	\N	Dorigo
388	Brian	\N	Flannery
389	Thomas	\N	Anderson
390	Ben	\N	Albahari
391	Gary	\N	Pollice
392	Jon	\N	Orwant
393	Dave	\N	Fancher
394	John	\N	Smart
395	Wallace	\N	Wang
396	Julian	\N	Assange
397	Alex	\N	Payne
398	Terence	\N	Parr
399	Kees	\N	Doets
400	Eldad	\N	Eilam
401	John	\N	Zelle
402	Marsha	\N	Zaidman
403	Kip	\N	Irvine
404	Deepak	\N	Alur
405	Magnus	\N	Christerson
406	Martin	\N	Abbott
407	F.	\N	Lawvere
408	Robert	\N	Harper
409	K.N.	\N	King
410	Diana	\N	Wright
411	Daniel	\N	Velleman
412	Frank	\N	OBrien
413	Andrew	\N	Farris
414	Niranjan	\N	Shivaratri
415	Don	\N	Jones
416	Adam	\N	Freeman
417	William	\N	Cook
418	Andrei	\N	Alexandrescu
419	Yehuda	\N	Katz
420	Richard	\N	Monson-Haefel
421	George	\N	Kurtz
422	Seth	\N	Stephens-Davidowitz
423	Martin	\N	Gardner
424	Bruce	\N	Lawson
425	Robert	\N	Knake
426	Ellen	\N	Ullman
427	John	\N	Crupi
428	Diana	\N	Larsen
429	Eric	\N	Giguere
430	Derek	\N	Balling
431	Paul	\N	Ceruzzi
432	Tom	\N	Fawcett
433	Jeff	\N	Johnson
434	Jon	\N	Gertner
435	Yashavant	\N	Kanetkar
436	Andy	\N	Oram
437	Kenneth	\N	Steiglitz
438	Trevor	\N	Hastie
439	Jeffrey	\N	Ullman
440	Adrian	\N	Holovaty
441	Kevin	\N	Kelly
442	Paul	\N	Barry
443	Uwe	\N	SchĂ¶ning
444	John	\N	Burgess
445	Christopher	\N	Steiner
446	Eric	\N	Redmond
447	Jon	\N	Erickson
448	Timothy	\N	Gowers
449	Karl	\N	Matthias
450	Jason	\N	Fried
451	Jacquelyn	\N	Carter
452	Jacob	\N	Appelbaum
453	Andrew	\N	Glover
454	John	\N	White
455	Ed	\N	Yourdon
456	The	\N	Consortium
457	Michael	\N	Lucas
458	Raphael	\N	Malveau
459	Simon	\N	Marlow
460	Ralph	\N	Johnson
461	Bjarne	\N	Stroustrup
462	Jeremy	\N	Kubica
463	Dan	\N	Malks
464	Michael	\N	Folk
465	Allen	\N	Dutoit
466	Jack	\N	Falk
467	Andrew	\N	Tanenbaum
468	Andrew	\N	Appel
469	Rachel	\N	Warren
470	Nick	\N	Rozanski
471	Gunnar	\N	Overgaard
472	Debra	\N	Cameron
473	Sanjay	\N	Patel
474	Greg	\N	Perry
475	Andrew	\N	Barto
476	Pedro	\N	Domingos
477	Mordechai	\N	Ben-Ari
478	John	\N	Koza
479	Peter	\N	Pacheco
480	David	\N	Bourg
481	Robert	\N	Martin
482	Philip	\N	Jackson
483	Paul	\N	Duvall
484	Paul	\N	Churchland
485	David	\N	Patterson
486	Roland	\N	Mas
487	Imre	\N	Leader
488	Michael	\N	Dirolf
489	Jerome	\N	Saltzer
490	James	\N	Whittaker
491	Betsy	\N	Beyer
492	Albert-László	\N	Barabási
493	Lisa	\N	Crispin
494	Peter	\N	Wallack
495	Trend-Pro	\N	Ltd.
496	Sydney	\N	Padua
497	Niklaus	\N	Wirth
498	James	\N	Foley
499	Lawrence	\N	Lessig
500	Edward	\N	Tufte
501	Carl	\N	Albing
502	Luke	\N	Hohmann
503	Mark	\N	Ryan
504	Richard	\N	Sutton
505	Fletcher	\N	Dunn
506	George	\N	Karypis
507	Maurice	\N	Naftalin
508	John	\N	Willis
509	Jez	\N	Humble
510	Neil	\N	Jones
511	Stanley	\N	Lippman
512	Simon	\N	Brown
513	Eric	\N	Lengyel
514	Marc	\N	Kreveld
515	Chris	\N	Jones
516	Andrew	\N	Hodges
517	Earle	\N	Castledine
518	F.	\N	Leighton
519	Philippe	\N	Flajolet
520	Peter	\N	Hart
521	Philip	\N	Japikse
522	Michael	\N	Ligh
523	Mark	\N	Richards
524	Gary	\N	Wright
525	Viktor	\N	Mayer-Schönberger
526	Gautam	\N	Shroff
527	Jonathan	\N	Stoddard
528	Richard	\N	Hamming
529	Cristina	\N	Lopes
530	Stoyan	\N	Stefanov
531	Michael	\N	Abrash
532	Bradley	\N	Miller
533	Jim	\N	Highsmith
534	Anthony	\N	Molinaro
535	Frank	\N	Buschmann
536	Peter	\N	Dayan
537	James	\N	Gleick
538	Tony	\N	Mason
539	Nell	\N	Dale
540	Kevin	\N	Fall
541	Ryan	\N	Breidenbach
542	Doug	\N	Hoyte
543	Remy	\N	Sharp
544	Chas	\N	Emerick
545	Daniel	\N	Shiffman
546	Flavio	\N	Junqueira
547	Nello	\N	Cristianini
548	Greg	\N	Wilson
549	Mike	\N	Cohn
550	Michael	\N	Lewis
551	Neal	\N	Gafter
552	William	\N	Byrd
553	Frederick	Jr.	Brooks
554	OReilly	\N	Team
555	Axel	\N	Rauschmayer
556	Andrew	\N	Ng
557	William	\N	Press
558	ACM	\N	Staff
559	Michael	\N	Fisher
560	John	\N	Lewis
561	Simon	\N	Haykin
562	Jim	\N	Blandy
563	Herbert	\N	Schildt
564	Rich	\N	Gibson
565	Markus	\N	Winand
566	Seymour	\N	Papert
567	Raghu	\N	Ramakrishnan
568	Greg	\N	Newman
569	Christopher	\N	Manning
570	Gregor	\N	Hohpe
571	Roland	\N	Kuhn
572	Doug	\N	Cutting
573	Daniel	\N	Cohen
574	Brian	\N	Foy
575	Alan	\N	Mycroft
576	Ian	\N	Witten
577	Chad	\N	Fowler
578	Ronen	\N	Feldman
579	Marvin	\N	Zelkowitz
580	Mana	\N	Takahashi
581	John	\N	Foreman
582	Andries	\N	Dam
583	John	\N	Hughes
584	William	\N	Kent
585	Gene	\N	Kim
586	Wes	\N	McKinney
587	Brian	\N	Totty
588	Matt	\N	Welsh
589	Gojko	\N	Adzic
590	Greg	\N	Nudelman
591	Dean	\N	Leffingwell
592	Peter	\N	Salus
593	Jared	\N	Richardson
594	Willi	\N	Richert
595	Winston	\N	Chang
596	Martin	\N	Odersky
597	Drew	\N	Neil
598	Gilbert	\N	Strang
599	Jon	\N	Loeliger
600	Christos	\N	Papadimitriou
601	Chris	\N	Shiflett
602	Glenn	\N	Greenwald
603	Mike	\N	Gancarz
604	Kevin	\N	Beaver
605	James	\N	Warren
606	Reto	\N	Meier
607	Jennifer	\N	Robbins
608	Mike	\N	Loukides
609	Aaron	\N	Tenenbaum
610	Anany	\N	Levitin
611	Joshua	\N	Bloch
612	Benjamin	\N	Reed
613	Michael	\N	Goldwasser
614	Marcus	\N	Pinto
615	Robert	\N	Vamosi
616	Tariq	\N	Rashid
617	Daphne	\N	Koller
618	James	\N	Reffell
619	Boaz	\N	Barak
620	Steven	\N	Holzner
621	Franz	\N	Baader
622	Sara	\N	Baase
623	Christel	\N	Baier
624	Jon	\N	Bentley
625	Hadley	\N	Wickham
626	Jeff	\N	Atwood
627	John	\N	Mongan
628	Jeff	\N	Hammerbacher
629	John	\N	Mitchell
630	Marc	\N	Goodman
631	John	\N	Allen
632	Neil	\N	Matthew
633	Tony	\N	Gaddis
634	Timothy	\N	Lister
635	Carl	\N	Meyer
636	Amy	\N	Brown
637	Eric	\N	Matthes
638	Dan	\N	Gusfield
639	Vincent	\N	Massol
640	Robert	\N	Romano
641	Christer	\N	Ericson
642	Andreas	\N	Zeller
643	Carolyn	\N	Begg
644	Claire	\N	Evans
645	Dusty	\N	Phillips
646	Dave	\N	Agans
647	Mark	\N	Berg
648	Felipe	\N	Leme
649	John	\N	Kelleher
650	Andy	\N	Hertzfeld
651	Samuel	\N	Arbesman
652	Max	\N	Jacobson
653	Yale	\N	Patt
654	Dick	\N	Grune
655	Michael	\N	Stonebraker
656	Tomas	\N	Akenine-Möller
657	Ken	\N	Schwaber
658	Michael	\N	Taylor
659	Grady	\N	Booch
660	Pete	\N	Goodliffe
661	Joshua	\N	Suereth
662	Garth	\N	Snyder
663	Leo	\N	Dorst
664	Barry	\N	OReilly
665	Jennifer	\N	Greene
666	Douglas	\N	Schmidt
667	Joseph	\N	Schmuller
668	Andrew	\N	Gelman
669	Karl	\N	Wiegers
670	Andreas	\N	Wirthensohn
672	Tom	\N	Liston
673	Dean	\N	Miller
674	Jakob	\N	Nielsen
675	Elaine	\N	Rich
676	Leland	\N	Purvis
677	Ivan	\N	Ristic
678	Richard	\N	Warburton
679	Michel	\N	Goossens
680	S.	\N	Cooper
681	Michael	\N	Mitzenmacher
682	Shamkant	\N	Navathe
683	Gordon	\N	Lyon
684	Matthew	\N	Gast
685	William	\N	Lidwell
686	Bruce	\N	Sterling
687	Chuck	\N	Musciano
688	Benjamin	\N	Lipchak
689	Peter	\N	Zaitsev
690	Keith	\N	Jones
691	Steven	\N	Levithan
692	Bryan	\N	OSullivan
693	Ken	\N	Ledeen
694	Christopher	\N	Alexander
695	Lar	\N	Kaufman
696	David	\N	Leavitt
697	Sam	\N	Williams
698	Marco	\N	Cesati
699	Alan	\N	Turing
700	Ira	\N	Pohl
701	Ernest	\N	Nagel
702	Eibe	\N	Frank
703	George	\N	Boolos
704	Peter	\N	Robson
705	Michael	\N	Lopp
707	Dean	\N	Wampler
708	Brett	\N	McLaughlin
709	P.J.	\N	Plauger
710	Herb	\N	Sutter
711	Peter	\N	Kim
712	Russ	\N	Miles
713	Alex	\N	Ionescu
714	Prabhakar	\N	Raghavan
715	Chris	\N	Anley
716	Mor	\N	Harchol-Balter
717	Neal	\N	Stephenson
718	Harry	\N	Lewis
719	Andriy	\N	Burkov
720	Vaughn	\N	Vernon
721	David	\N	Barber
722	David	\N	Kahn
723	Toby	\N	Segaran
724	Holden	\N	Karau
725	Nancy	\N	Lynch
726	Shawn	\N	Hedman
727	Peter	\N	Hruschka
728	Sailu	\N	Reddy
729	Christophe	\N	Grand
730	Daniel	\N	Holden
731	Joseph	\N	Bonneau
732	Andrew	\N	Blum
733	Mark	\N	Overmars
734	Miran	\N	LipovaÄŤa
735	Gerald	\N	Weinberg
736	Aoife	\N	DArcy
737	Anthony	\N	Williams
738	Kent	\N	Kawahara
739	Jeff	\N	Duntemann
740	Robert	\N	Glass
741	Donald	\N	Yacktman
742	Terrence	\N	Pratt
743	Rachid	\N	Guerraoui
744	Jan	\N	Goyvaerts
745	Steve	\N	Oualline
746	Edsger	\N	Dijkstra
747	Jaron	\N	Lanier
748	Bruce	\N	Dang
749	Adam	\N	Tornhill
750	Robert	\N	Maksimchuk
751	Jon	\N	Skeet
752	Richard	\N	Clarke
753	David	\N	Goldberg
754	Vadim	\N	Tkachenko
755	Jeff	\N	Langr
756	Andrew	\N	Case
757	Ă†leen	\N	Frisch
758	Robert	\N	Tibshirani
759	Edward	\N	Loper
760	Martin	\N	Kleppmann
761	Narasimha	\N	Karumanchi
762	Elias	\N	Bachaalany
763	Adam	\N	Chlipala
764	Jamie	\N	Allen
765	Ellen	\N	Siever
766	Don	\N	Widrig
767	Laurence	\N	Abbott
768	Hung	\N	Nguyen
769	Alvaro	\N	Videla
770	Nikhil	\N	Buduma
771	LuĂ­s	\N	Rodrigues
772	Stephen	\N	Schanuel
773	Kim	\N	Zetter
774	Raoul-Gabriel	\N	Urma
775	Remzi	\N	Arpaci-Dusseau
776	Linda	\N	Liukas
777	Mukesh	\N	Singhal
778	Ron	\N	Sigal
779	Paul	\N	Hudak
780	Jonathan	\N	Rosenberg
781	Duane	\N	Bibby
782	Ajay	\N	Agrawal
783	Brendan	\N	Gregg
784	Trevor	\N	Foucher
785	Steven	\N	Bird
786	Jimmy	\N	Nilsson
787	David	\N	Herman
788	Aaron	\N	Hillegass
789	Edward	\N	Reingold
790	Tom	\N	White
791	Christopher	\N	Bishop
792	Cathy	\N	Lazere
793	Mark	\N	Chu-Carroll
794	Gerard	\N	Tel
795	Jeffrey	\N	Zeldman
796	James	\N	Grenning
797	Antonio	\N	Goncalves
798	György	E.	Révész
799	Robert	\N	Reimann
800	Tom	\N	Poppendieck
801	William	\N	Poundstone
802	George	\N	Reese
803	Susannah	\N	Pfalzer
804	Chris	\N	Sims
805	Mark	\N	Sobell
806	Philipp	\N	Janert
807	Nicolai	\N	Josuttis
808	Michael	\N	Huth
809	Jonathan	\N	Seldin
810	William	\N	Couie
811	Dave	\N	Shreiner
812	Gabriella	\N	Coleman
813	Douglas	\N	Comer
814	Indra	\N	Widjaja
815	Albert	\N	Woodhull
816	Daniel	\N	Brolund
817	Jeremy	\N	Kun
818	Curtis	\N	Rose
819	Vijay	\N	Vazirani
820	Leonard	\N	Richardson
821	Mitchell	\N	Wand
822	Jonas	\N	BonA©r
823	Judea	\N	Pearl
824	Richard	Jr.	Wright
825	Jeff	\N	Sutherland
826	Scott	\N	McCartney
827	Mikko	\N	Lipasti
828	George	\N	Varghese
829	Alessandro	\N	Rubini
830	Behrouz	\N	Forouzan
831	Marc	\N	Loy
832	Micheline	\N	Kamber
833	Jamis	\N	Buck
834	John	\N	Carlin
835	John	\N	Lions
836	Ivar	\N	Jacobson
837	Ben	\N	Clark
838	Joseph	\N	Weizenbaum
839	John	\N	Resig
840	Stephen	\N	Huston
841	Simon	\N	Collison
842	Bill	\N	Phillips
843	Jake	\N	Vanderplas
844	David	\N	Black
845	Hans	\N	Rohnert
846	Arthur	\N	Riel
847	Doug	\N	Brown
848	James	\N	Newman
849	David	\N	Harris
850	Swaroop	\N	C.H.
851	Hsuan-Tien	\N	Lin
852	Dana	\N	Mackenzie
853	Ray	\N	Kurzweil
854	Walter	\N	Isaacson
855	Brian	\N	Okken
856	Donald	\N	Knuth
857	Ben	\N	Forta
858	Hannah	\N	Fry
859	Philip	\N	Klein
860	Sanjoy	\N	Dasgupta
861	Walter	\N	Savitch
862	Uwe	\N	Schöning
863	J.	\N	Scott
864	George	\N	Neville-Neil
865	Leon	\N	Breedt
866	Donald	\N	Norman
867	David	\N	McFarland
868	Conrad	\N	Barski
869	Nathaniel	\N	Popper
870	Martin	\N	Logan
871	Randall	\N	Hyde
872	Raymond	\N	Chen
873	Emil	\N	Eifrem
874	Kevin	\N	Murphy
875	A.E.	\N	Eiben
876	Andreas	\N	Antonopoulos
877	Dan	\N	Pilone
878	George	\N	Luger
879	Nat	\N	Pryce
880	Mark	\N	Bowden
881	Eben	\N	Hewitt
882	Joshua	\N	Gay
883	Ryan	\N	Boyd
884	David	\N	Solomon
885	Alistair	\N	Cockburn
886	Melanie	\N	Mitchell
887	Sam	\N	Ruby
888	B.	\N	Copeland
889	Clifford	\N	Stoll
890	Paul	\N	Butcher
891	Roger	\N	Penrose
892	Alberto	\N	Leon-Garcia
893	Thomas	\N	Sudkamp
894	Gary	\N	Flake
895	Aurélien	\N	Géron
896	Susanne	\N	Teschl
897	Jacob	\N	Kaplan-Moss
898	Robert	\N	Sedgewick
899	Tobias	\N	Klein
900	Rob	\N	Goodman
901	Jamie	\N	Bartlett
902	Nicholas	\N	Carr
903	Steve	\N	Wozniak
904	Michael	\N	Dawson
905	J.E.	\N	Smith
906	Grant	\N	Ingersoll
907	David	\N	Anderson
908	Thomas	\N	Limoncelli
909	Peter	\N	Kogge
910	Zvonko	\N	Vranesic
911	Luis	\N	Coelho
912	Cameron	\N	Newham
913	Zbigniew	\N	Michalewicz
914	T.J.	\N	OConnor
915	Vipin	\N	Kumar
916	Kristina	\N	Chodorow
917	Ceriel	\N	Jacobs
918	Casey	\N	Reas
919	Mirco	\N	Mannucci
920	Adnan	\N	Aziz
921	Luke	\N	Muehlhauser
922	Daniel	\N	Dennett
923	Frank	\N	Mittelbach
924	Marjorie	\N	Sayer
925	Jeff	\N	Carollo
926	Kenneth	\N	Cukier
927	A.K.	\N	Dewdney
928	Helen	\N	Gaines
929	Audrey	\N	Greenfeld
930	M.	\N	Mano
931	Keith	\N	Cooper
932	Simon	\N	Thompson
933	Greg	\N	Gagne
934	Per	\N	Hansen
935	Paul	\N	Wilson
936	Otfried	\N	Schwarzkopf
937	Nathan	\N	Torkington
938	David	\N	Vise
939	Jeremy	\N	Zawodny
940	Paul	\N	Horowitz
941	Douglas	\N	Rushkoff
942	David	\N	Christiansen
943	Joe	\N	Celko
944	Samuel	III	Harbison
945	Michael	\N	Tilson
946	John	\N	Heasman
947	Yaser	\N	Abu-Mostafa
948	Eric	\N	Haines
949	Paul	\N	Vitányi
950	Noam	\N	Nisan
951	Mark	\N	Summerfield
952	Evi	\N	Nemeth
953	Adewale	\N	Oshineye
954	John	\N	Markoff
955	Zach	\N	Dennis
956	Matthias	\N	Felleisen
957	Ola	\N	Ellnestam
958	Peter	\N	Harrington
959	Aaron	\N	Weber
960	Anil	\N	Madhavapeddy
961	Bob	\N	Baxley
963	Kyle	\N	Simpson
964	David	\N	Rogers
965	Jürgen	\N	Holdorf
966	Warren	\N	Weaver
967	Ian	\N	Goodfellow
968	Hillary	\N	Johnson
969	Barbara	\N	Moo
970	Justin	\N	Seitz
971	Eric	\N	Raymond
972	Edward	\N	Yourdon
973	Mark	\N	Seemann
974	Bobbi	\N	Young
975	Jim	\N	Conallen
976	Edwin	\N	Brady
977	Steve	\N	Krug
978	Jonathan	\N	Rasmusson
979	Russ	\N	Olsen
980	Paul	\N	Vigna
981	Kelsey	\N	Hightower
982	Caroline	\N	Jarrett
983	Keith	\N	Frankish
984	Joseph	\N	Albahari
985	Allen	\N	Downey
987	Peter	\N	Seibel
988	Peter	\N	Norvig
989	David	\N	Flanagan
990	April	\N	Chu
991	Marshall	\N	McKusick
992	Rick	\N	Kazman
993	Cynthia	\N	Andres
994	Francesco	\N	Cesarini
995	Pavel	\N	Pevzner
996	Andrew	\N	Koenig
997	Anshu	\N	Aggarwal
998	Krzysztof	\N	Cwalina
999	John	\N	Pierce
1000	Alexander	\N	Stepanov
1001	Blake	\N	Masters
1002	Stephen	\N	Prata
1003	Thomas	\N	Cormen
1004	Joshua	\N	Kerievsky
1005	Niall	\N	Murphy
1006	Patrick	\N	Niemeyer
1007	Udi	\N	Manber
1008	Tom	\N	Stuart
1009	Kate	\N	Thompson
1010	Joshua	\N	Gans
1011	Paolo	\N	Perrotta
1012	David	\N	Horn
1013	Lex	\N	Spoon
1014	Henry	\N	Korth
1015	Bill	\N	Wagner
1016	Matt	\N	Carter
1017	Philip	\N	Wadler
1018	Pete	\N	McBreen
1019	Paul	\N	Graham
1020	Dave	\N	Hoover
1021	Robert	\N	Cringely
1022	Stephen	\N	Davis
1023	Kurt	\N	Beyer
1024	Christian	\N	Rudder
1025	Randal	\N	Schwartz
1026	Alan	\N	Beaulieu
1027	Jamie	\N	Taylor
1028	Bill	\N	Rosenblatt
1029	David	\N	West
1030	Ben	\N	Whaley
1031	Donald	\N	Stewart
1032	Christopher	\N	Date
1033	Ă‰va	\N	Tardos
1034	Tadayoshi	\N	Kohno
1035	George	\N	Coulouris
1036	Gary	\N	Gregory
1037	Cricket	\N	Liu
1038	Elizabeth	\N	Castro
1039	Jay	\N	Wengrow
1040	Dave	\N	Thomas
1041	Murray	\N	Silverstein
1042	Scott	\N	Oaks
1043	Apostolos	\N	Doxiadis
1044	Peter	Linden	der
1045	Robin	\N	Williams
1046	Saul	\N	Teukolsky
1047	Anand	\N	Rajaraman
1048	Daniel	\N	Bovet
1049	Kevin	\N	Goldberg
1050	Mark	\N	Masse
1051	Andrew	\N	Troelsen
1052	William	\N	Aspray
1053	Adam	\N	Shook
1054	Ryan	\N	Mitchell
1055	Christian	\N	Cachin
1056	Avi	\N	Goldfarb
1057	Max	\N	Kanat-Alexander
1058	Noson	\N	Yanofsky
1059	Elbert	\N	Hannah
1060	Bill	\N	Venners
1061	Rafael	\N	Gonzalez
1062	Eric	\N	Bonabeau
1063	Richard	\N	Trudeau
1064	Ananth	\N	Grama
1065	Robert	\N	Daigneau
1066	A†leen	\N	Frisch
1067	Adam	\N	Drozdek
1068	Alfred	\N	Menezes
1069	Hal	\N	Stern
1070	P.W.	\N	Singer
1071	Shoko	\N	Azuma
1072	Malik	\N	Magdon-Ismail
1073	Daniel	\N	Greenfeld
1074	Kurt	\N	Mehlhorn
1075	Kevin	\N	Leyton-Brown
1076	Scott	\N	Page
1077	Brian	\N	Christian
1078	John	\N	Neumann
1079	Jane	\N	Margolis
1080	Adrian	\N	Kaehler
1081	Allen	\N	Harper
1082	Steven	\N	Muchnick
1083	Herbert	\N	Simon
1084	Stuart	\N	Halloway
1085	Ken	\N	Arnold
1086	Joseph	\N	Hellerstein
1087	Rob	\N	Conery
1088	Gerard	\N	Meszaros
1089	Kritina	\N	Holden
1090	Niels	\N	Ferguson
1091	Annie	\N	Donna
1092	Jim	\N	Gray
1093	Oleg	\N	Kiselyov
1094	Ian	\N	Wienand
1095	Trevor	\N	Burnham
1096	Josh	\N	Patterson
1097	Amy	\N	Langville
1098	C.A.R.	\N	Hoare
1099	Susanna	\N	Epp
1100	Rina	\N	Dechter
1101	Eric	\N	Sink
1102	Carlos	\N	Varela
1103	Lawrie	\N	Brown
1104	Jonathan	\N	Corbet
1105	Andrew	\N	Rudoff
1106	James	\N	Gosling
1107	Steve	\N	Maguire
1108	Michael	\N	Howard
1109	Audrey	\N	Roy
1110	David	\N	Easley
1112	Jean	\N	Dollimore
1113	James	\N	Sanger
1114	Gerald	\N	Teschl
1115	Eric	\N	Merritt
1116	Damian	\N	Conway
1117	Roy	\N	Osherove
1118	Randy	\N	Pausch
1119	Scott	\N	Millett
1120	Hays	McCormick	Skip
1121	Jack	\N	Koziol
1122	John	\N	Allspaw
1123	Jonathan	\N	Bartlett
1124	Eli	\N	Bressert
1125	Julia	\N	Lobur
1126	David	\N	Fogel
1127	Dafydd	\N	Stuttard
1128	Jason	\N	Arbon
1129	Thomas	\N	Fuchs
1130	Charlie	\N	Hunt
1131	Patrik	\N	Jonsson
1132	Benjamin	\N	Pierce
1133	Sanjeev	\N	Arora
1134	Noah	\N	Suojanen
1135	Jeffrey	\N	Hicks
1136	Brian	\N	Macnamee
1137	Ada	\N	Lovelace
1138	Ehud	\N	Shapiro
1139	Jim	\N	Webber
1140	Josée	\N	Lajoie
1141	Scott	\N	Granneman
1142	Clinton	\N	Gormley
1143	David	\N	Kadavy
1144	James	\N	Broad
1145	Bryan	\N	Basham
1146	Yehuda	\N	Lindell
1147	Richard	\N	Stones
1148	Len	\N	Bass
1149	Leon	\N	Sterling
1150	Stephen	\N	Brown
1151	Max	\N	Kuhn
1152	Jim	\N	Ottaviani
1153	Nick	\N	Bilton
1154	Jesse	\N	Storimer
1155	Leslie	\N	Valiant
1156	Robert	\N	Love
1157	Robert	\N	Lafore
1158	Michael	\N	Heath
1159	D.S.	\N	Malik
1160	Richard	\N	Carlsson
1161	Raphaël	\N	Hertzog
1162	Haralambos	\N	Marmanis
1163	John	\N	Miller
1164	Hubert	\N	Dreyfus
1165	Michael	\N	Sikorski
1166	Erik	\N	Brynjolfsson
1167	Ramez	\N	Elmasri
1168	Erik	\N	Buck
1169	Ron	\N	Patton
1170	Brian	\N	Kernighan
1171	Dmitry	\N	Babenko
1172	Yves	\N	Bertot
1173	37	\N	Signals
1174	Dustin	\N	Boswell
1175	Bertrand	\N	Meyer
1176	Stephen	\N	Mann
1177	David	\N	Hansson
1178	Brian	\N	Hardy
1179	Sandra	\N	Blakeslee
1180	Mason	\N	Woo
1181	Rod	\N	Stephens
1182	Andrew	\N	Bruce
1183	Martin	\N	Campbell-Kelly
1184	James	\N	Elliott
1185	J.	\N	Hindley
1186	Michael	\N	Engle
1187	Kenneth	\N	Louden
1188	Mig	\N	Greengard
1189	Richard	\N	Jones
1190	Alex	\N	Tapscott
1191	Frank	\N	Pasquale
1192	Gene	\N	Spafford
1193	Raymond	\N	Smullyan
1194	Christopher	\N	Allen
1195	Julie	\N	Moronuki
1196	Craig	\N	Walls
1197	Bruce	\N	Schneier
1198	Caleb	\N	Doxsey
1199	John	\N	Vlissides
1200	Dave	\N	Astels
1201	Reshma	\N	Saujani
1202	Noam	\N	Nison
1203	Drew	\N	Conway
1204	James	\N	Martin
1205	Maurice	\N	Bach
1206	Stephen	\N	Marsland
1207	Andy	\N	Terrel
1208	Joe	\N	Kutner
1209	Brian	\N	Jones
1210	Andrew	\N	Davison
1211	Nachum	\N	Dershowitz
1212	Matthew	\N	Hahn
1213	Mark	\N	Weiss
1214	Kevin	\N	Mitnick
1215	John	\N	Ousterhout
1216	Elisabeth	\N	Hendrickson
1217	Wesley	\N	Chun
1218	Tim	\N	Wu
1219	Ian	\N	Robinson
1220	Gigi	\N	Estabrook
1221	Andy	\N	Hunt
1222	Alexandre	\N	Gazet
1223	James	\N	Barrat
1224	Joel	\N	Grus
1225	Doug	\N	Hellmann
1226	Jonathan	\N	Knudsen
1227	Patricia	\N	Churchland
1228	David	\N	Ascher
1229	Antonio	\N	MartAfÂ­nez
1230	Michael	\N	Fogus
1231	Richard	\N	Szeliski
1232	Michael	\N	Casey
1233	Ben	\N	Fry
1234	David	\N	Kushner
1235	Daniel	\N	Fontijne
1236	Ole-Johan	\N	Dahl
1237	Ben	\N	Klemens
1238	V.	\N	Hamacher
1239	Patrick	\N	Engebretson
1240	Alex	\N	Martelli
1241	Scott	\N	Meyers
1242	Justin	\N	Zobel
1243	Thomas	\N	Morton
1244	Douglas	\N	West
1245	Jill	\N	Butler
1246	Marvin	\N	Minsky
1247	Savas	\N	Parastatidis
1248	John	\N	Goerzen
1249	Donald	\N	Reinertsen
1250	Aaron	\N	Gustafson
1251	Winfield	\N	Hill
1252	Aslak	\N	Hellesoy
1253	Tim	\N	OReilly
1254	John	\N	Guttag
1255	Isaac	\N	Chuang
1256	Robin	\N	Milner
1257	Pekka	\N	Himanen
1258	Vitalik	\N	Buterin
1259	Nathan	\N	Yau
1260	Michael	\N	Wittig
1261	Craig	\N	Hunt
1262	Michael	\N	Morrison
1263	David	\N	Rensin
1264	Christian	\N	Queinnec
1265	Rachel	\N	Schutt
1266	Brett	\N	Slatkin
1267	Yedidyah	\N	Langsam
1268	Donald	\N	Miner
1269	Daniel	\N	Friedman
1270	David	\N	Agans
1271	Thomas	\N	Cover
1272	Cristopher	\N	Moore
1273	Jeremy	\N	Keith
1274	Richard	\N	Duda
1275	Jay	\N	Fields
1276	Joel	\N	Spolsky
1277	John	\N	Levine
1278	Bill	\N	Kennedy
1279	Steven	\N	Levy
1280	David	\N	Diamond
1281	Glynn	\N	Winskel
1282	Gary	\N	Cornell
1283	W.	\N	Stevens
1284	Aaron	\N	Walters
1285	Peter	\N	Shirley
1286	Shriram	\N	Krishnamurthi
1287	Alan	\N	Shalloway
1288	Sarah	\N	Harris
1289	Karim	\N	Yaghmour
1290	Al	\N	Sweigart
1291	Debasish	\N	Ghosh
1292	William	\N	Mougayar
1293	Stephane	\N	Faroult
1294	Brett	\N	Lantz
1295	Michael	\N	Goodrich
1296	Eric	\N	Schmidt
1297	Raimondo	\N	Pictet
1298	Brian	\N	Ward
1299	Peter	\N	Denning
1300	Vint	\N	Cert
1301	Peter	\N	Abel
1302	Cory	\N	Doctorow
1303	Matei	\N	Zaharia
1305	Elisabeth	\N	Robson
1306	Sean	\N	Kane
1307	Eric	\N	Lehman
1308	Al	\N	Kelley
1309	John	\N	Gall
1310	Yaron	\N	Minsky
1311	Glyn	\N	Moody
1312	Jon	\N	Stokes
1313	Joel	\N	Scambray
1314	Eric	\N	Freeman
1315	Ken	\N	Thompson
1316	John	\N	Lakos
1317	Andrew	\N	Huang
1319	Paul	\N	McJones
1320	Ewan	\N	Klein
1321	Artur	\N	Ejsmont
1322	Hans	Baeyer	Von
1323	Joy	\N	Beatty
1324	William	\N	Stallings
1325	Satnam	\N	Alag
1327	George	\N	Fairbanks
1328	Linda	\N	Lamb
1329	Ian	\N	Millington
1330	Andy	\N	Budd
1331	Stephen	\N	Kochan
1332	Yukihiro	\N	Matsumoto
1333	Bobby	\N	Woolf
1334	Guy	Jr.	Steele
1335	Leland	\N	Wilkinson
1336	Parmy	\N	Olson
1337	Bartosz	\N	Milewski
1338	Jerry	\N	Peek
1339	Peter	\N	Galvin
1340	Doug	\N	Lea
1341	David	\N	Simon
1342	Arvind	\N	Narayanan
1343	Edward	\N	Felten
1344	Elaine	\N	Weyuker
1345	Martin	\N	Erwig
1346	Michael	\N	Hiltzik
1347	Johannes	\N	Gehrke
1348	Carl	\N	Gunter
1349	Pat	\N	Shaughnessy
1350	Michal	\N	Zalewski
1351	Alan	Donovan	A.
1352	Joanne	\N	Molesky
1353	William	\N	Vetterling
1354	Kathy	\N	Sierra
1355	Esther	\N	Derby
1356	Jeffrey	\N	Ulman
1357	Hartmut	\N	Bohnacker
1358	Cem	\N	Kaner
1359	Jonathan	\N	Gennick
1360	Cole	\N	Knaflic
1361	Michael	\N	Nygard
1362	Umesh	\N	Vazirani
1363	G.	\N	Zachary
1364	Nigel	\N	Cutland
1365	Joe	\N	Beda
1366	Glenford	\N	Myers
1367	Eric	\N	Roberts
1368	Gabe	\N	Zichermann
1369	John	\N	McDonald
1370	Peter	\N	Rob
1371	Steve	\N	McConnell
1372	Steven	\N	Goldfeder
1373	Mark	\N	Fenoglio
1374	Max	\N	Tegmark
1375	Laurie	\N	Wallmark
1376	Colleen	\N	Gorman
1377	Bear	\N	Bibeault
1378	Nicholas	\N	Zakas
1379	Herbert	\N	Mattord
1380	Bernd	\N	Bruegge
1381	Don	\N	Tapscott
1382	Jason	\N	Brownlee
1383	Anthony	\N	Hey
1384	Jiawei	\N	Han
1385	Andreas	\N	Schwarz
1386	Jennifer	\N	Widom
1387	Larry	\N	Wall
1388	Seth	\N	Lloyd
\.


--
-- Data for Name: book_authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book_authors (book_id, author_id) FROM stdin;
1	176
1	533
1	657
1	800
2	921
3	325
4	386
5	631
6	699
7	1038
7	1049
8	534
9	412
10	372
10	1016
11	909
12	326
13	683
14	810
15	1021
16	424
16	543
17	801
18	439
19	211
20	708
21	735
22	578
22	1113
23	1100
24	349
24	601
24	937
25	700
25	1308
26	1158
27	741
27	1168
28	788
29	345
30	554
31	811
31	1180
32	708
32	1210
33	896
33	1114
34	666
34	840
35	314
35	1368
36	425
36	752
37	1015
41	1159
42	227
42	350
43	1249
44	1341
45	499
46	193
47	735
48	94
49	620
50	1101
51	113
52	745
80	1094
81	546
81	612
82	1073
82	1109
102	16
103	85
104	602
105	590
106	185
107	477
108	804
108	968
109	151
110	393
111	793
112	155
112	746
113	186
113	1379
114	415
114	1135
115	606
116	1363
117	1216
118	1225
119	293
119	639
119	648
119	1036
120	816
120	957
121	1050
122	804
122	968
123	276
124	294
124	351
124	937
125	1305
125	1314
126	285
127	753
128	794
129	890
130	500
131	526
132	70
132	241
133	64
133	922
134	455
134	591
134	766
135	1169
136	667
137	802
138	910
138	1150
139	789
139	1211
140	1197
141	628
141	640
141	723
142	1102
143	298
143	1151
144	114
145	29
145	327
145	378
145	1275
146	1289
147	394
148	121
149	143
149	1357
150	309
151	286
152	433
153	676
153	1152
154	1309
155	332
155	1299
155	1300
156	1
156	870
156	1115
156	1160
157	109
157	535
157	666
158	747
159	521
159	1051
160	833
161	527
162	456
163	1141
164	928
165	373
165	387
165	1062
166	951
167	1305
167	1314
168	607
169	929
169	1073
170	536
170	767
171	663
171	1176
171	1235
172	374
172	1142
173	248
173	668
173	834
173	1069
174	194
174	370
174	1369
175	177
176	144
176	1074
177	434
178	677
179	416
180	242
181	678
182	65
183	302
183	1070
184	104
184	505
185	795
185	1273
186	156
187	812
188	48
189	1063
189	1244
190	716
191	352
192	76
193	360
194	98
194	346
194	402
195	1191
196	786
197	1153
198	251
199	1301
200	403
201	152
205	178
206	145
206	689
206	754
223	822
224	1181
225	603
239	562
240	822
241	1095
242	1039
243	90
244	426
245	99
246	278
247	658
248	157
248	1182
249	228
249	891
250	855
251	980
251	1232
252	229
253	163
253	310
253	983
254	1170
255	1045
256	462
257	469
257	724
258	66
258	1075
259	555
260	1321
261	279
261	604
262	187
263	598
264	261
265	486
265	1161
266	509
266	664
266	1352
267	1022
268	657
269	649
269	736
269	1136
270	1322
271	556
272	1329
273	669
273	1323
274	17
274	266
275	796
276	761
277	813
278	861
279	22
280	478
281	320
281	1137
282	1118
283	136
283	295
283	315
284	122
284	621
285	989
286	1032
287	1256
288	932
288	994
289	37
290	38
290	693
290	718
291	579
291	742
292	871
293	212
293	506
293	915
293	1064
294	547
294	1212
295	861
296	82
296	593
297	802
298	1334
299	563
300	650
300	903
301	573
302	1324
303	1281
304	83
304	1130
305	563
306	338
306	592
306	835
306	945
306	1315
307	1197
308	814
308	892
309	1364
310	862
311	64
312	151
312	1282
313	294
313	1220
314	238
314	1192
315	510
315	995
316	826
317	218
318	938
319	735
320	709
321	632
321	1147
322	969
322	996
323	719
324	633
325	594
325	911
326	327
326	404
326	427
326	463
326	659
327	507
327	1017
328	1283
329	666
329	845
330	173
330	379
330	1052
330	1183
331	817
332	1187
333	958
334	608
335	435
336	1154
337	199
338	382
338	464
339	477
340	110
340	933
340	1339
341	904
342	1162
342	1171
343	436
343	548
344	110
344	933
344	1339
345	347
345	949
346	197
347	205
347	1257
348	1290
349	1206
350	1291
351	156
351	690
351	818
352	23
353	353
354	30
355	465
355	1380
356	528
357	388
357	557
357	1046
357	1353
358	880
359	57
359	841
359	1330
360	1079
361	1170
362	206
362	805
363	875
363	905
364	737
364	1381
365	1018
366	564
366	1305
366	1314
366	1354
367	95
368	622
369	2
369	105
370	710
371	641
372	1382
373	280
373	1080
374	1023
375	31
375	1188
376	158
376	1096
377	281
378	123
379	287
379	964
380	537
381	1324
382	243
382	1275
383	462
384	213
385	394
386	1258
386	1292
387	316
387	321
388	1119
389	220
389	448
389	487
390	449
390	1306
391	39
392	755
392	1040
392	1221
393	10
393	827
394	1259
395	609
395	1267
396	252
397	164
397	389
398	1076
398	1163
399	529
400	479
401	457
402	490
403	413
403	906
403	1243
404	871
405	151
405	1282
406	303
406	354
406	634
406	727
407	58
407	522
407	756
407	1284
408	466
408	768
408	1358
409	797
410	282
410	1122
411	115
411	348
412	365
412	501
412	912
413	221
413	769
414	283
415	1051
417	1065
418	6
419	24
420	1103
420	1324
421	390
421	984
422	1198
423	124
423	623
424	1066
425	1053
425	1268
426	131
426	960
426	1310
427	188
427	304
427	355
427	679
427	923
428	440
428	897
429	549
430	932
431	867
432	1348
433	1164
434	801
435	32
436	795
437	893
438	846
439	684
440	530
441	1331
442	1302
443	480
444	828
445	635
445	1097
446	819
447	253
447	470
448	934
449	624
450	100
450	587
450	728
450	924
450	997
451	1311
452	781
452	856
453	1359
454	101
454	829
454	1104
455	67
455	1262
456	622
457	405
457	471
457	558
457	836
457	1131
458	535
458	845
459	1316
460	146
460	1148
461	1199
462	18
463	84
464	502
465	288
465	491
465	738
465	1005
465	1263
466	339
466	981
466	1365
467	262
468	770
469	7
469	670
469	965
470	40
471	748
471	762
471	1222
472	1360
473	651
474	71
475	1155
476	91
476	340
477	165
478	685
478	1089
478	1245
479	211
480	96
481	531
482	1156
483	125
484	1335
485	1015
486	303
487	669
488	1325
489	686
490	704
490	1293
491	898
492	680
493	17
494	492
495	311
495	356
495	1170
496	511
497	59
497	493
497	549
497	393
498	328
498	544
498	729
499	1331
500	798
501	823
502	642
503	1276
503	1282
504	548
504	636
505	1305
505	1314
506	660
507	430
507	939
508	214
508	285
508	296
508	380
508	494
508	618
508	961
508	982
508	1250
509	215
509	458
509	1120
510	881
511	898
512	428
512	657
512	1355
513	406
513	559
514	1217
515	898
516	856
517	629
518	1324
519	1246
520	1246
521	1067
522	1329
523	951
524	876
525	940
525	1251
526	230
526	322
526	357
526	652
526	694
526	1041
527	72
527	467
528	1317
529	289
529	333
530	1054
531	954
532	1229
533	776
534	1009
535	395
536	523
537	189
538	366
539	481
540	441
541	290
541	643
542	53
543	990
543	1375
544	746
544	1098
544	1236
545	297
545	1260
546	375
546	499
546	882
547	720
548	102
549	755
550	563
551	941
552	761
553	317
554	1024
555	44
555	299
556	563
558	970
559	730
560	1349
561	899
562	414
562	777
563	431
564	1294
565	711
566	922
567	550
568	207
569	743
569	771
569	1055
570	153
571	1317
572	595
573	1237
574	488
574	916
595	830
596	1123
597	326
598	97
598	657
628	137
628	159
628	168
629	907
630	77
630	254
631	1213
632	1285
633	450
633	1177
634	407
634	772
635	1157
636	1143
637	1083
638	763
639	116
640	267
641	68
641	1354
642	1238
643	147
643	277
644	200
644	517
645	27
646	1006
646	1226
647	705
648	367
648	723
648	1027
649	263
650	830
651	1032
652	856
653	801
654	28
655	705
656	106
656	231
656	1366
657	117
657	169
657	264
657	451
657	955
657	1200
657	1252
658	524
658	1283
659	1098
660	1172
661	1189
662	371
662	1370
663	472
663	831
663	971
663	1028
663	1184
664	757
665	1261
666	259
667	856
668	710
669	341
669	408
669	942
669	1269
670	129
670	518
670	1307
671	179
672	482
673	1371
674	555
675	782
675	1010
675	1056
676	598
677	1201
678	180
679	985
680	255
681	339
682	294
682	608
682	1376
683	500
684	723
685	11
685	731
685	1342
685	1343
685	1372
686	268
686	574
686	1025
687	442
688	976
689	1291
690	630
691	12
692	1011
693	431
694	130
695	1327
696	512
697	78
697	1207
698	473
698	653
699	86
699	665
700	199
700	778
700	1344
701	571
701	764
702	222
702	672
703	842
703	1178
704	170
704	613
704	1295
705	1144
705	1239
706	883
707	459
708	417
709	625
710	467
711	1124
712	596
712	661
713	378
714	208
714	1110
715	223
715	342
715	396
715	452
716	746
717	908
718	732
719	52
720	174
721	256
722	943
723	745
724	989
725	654
725	917
726	856
727	856
728	872
729	1312
730	1240
731	712
731	877
732	329
733	538
733	847
733	1277
734	176
734	800
735	68
735	1145
735	1354
736	725
737	118
738	1116
739	687
739	1278
740	160
741	644
742	232
742	305
742	1081
743	54
743	344
744	1345
745	1383
746	749
747	843
748	1040
749	233
750	474
750	673
751	739
752	956
752	1269
753	809
753	1185
754	624
755	863
756	269
756	1303
757	1042
758	837
759	783
760	201
761	565
762	645
763	270
764	418
764	710
765	111
765	713
765	884
766	1208
767	1090
767	1197
768	249
768	453
768	483
769	857
770	1213
771	1218
772	721
773	539
773	560
774	1230
775	1336
776	726
777	787
778	171
778	271
779	41
779	1165
780	788
780	1373
781	1138
781	1149
782	985
783	584
784	1026
785	64
785	701
785	848
786	244
786	1125
787	419
787	1377
788	1367
789	972
790	397
790	707
791	1187
792	803
792	1084
793	361
793	688
793	824
794	257
795	1277
796	312
796	918
796	1233
797	674
798	148
799	9
800	409
801	468
802	111
802	713
802	884
803	60
804	443
805	495
805	580
805	1071
806	181
806	714
807	779
808	977
809	878
810	313
811	1378
812	489
813	251
813	950
813	1033
813	1202
814	561
815	588
815	695
816	260
816	1105
816	1283
817	376
817	1085
817	1106
818	838
819	61
819	133
820	913
820	1126
821	885
822	1340
823	858
824	62
824	900
825	1241
826	112
826	1269
827	901
828	138
829	362
829	381
830	859
831	190
831	1001
832	655
832	1086
833	45
834	637
835	581
836	1378
837	238
838	33
838	410
839	1138
839	1149
840	540
840	1283
841	868
841	956
841	1012
842	64
843	572
843	790
844	886
845	311
845	439
846	599
847	566
848	589
849	34
849	610
850	747
851	378
852	513
853	1057
854	92
854	998
855	3
855	600
855	1043
855	1091
856	318
856	1146
857	468
858	646
858	1270
859	1011
860	8
860	1037
861	119
861	935
862	468
863	806
864	856
865	978
866	4
866	161
866	1068
867	166
868	932
869	111
869	713
869	884
870	170
870	1157
870	1295
871	696
872	697
873	864
873	991
874	979
875	1346
876	1264
877	378
877	549
878	1139
878	1219
878	1247
879	1286
880	549
881	791
882	306
882	903
883	567
883	1347
884	420
885	717
886	1019
887	886
888	1107
889	307
889	1108
890	545
891	930
892	807
893	25
893	311
893	439
894	437
894	600
895	856
896	638
897	216
897	327
897	460
898	461
899	334
899	1287
900	54
901	1190
901	1381
902	245
903	239
904	825
905	343
905	432
906	167
906	966
907	902
908	1029
909	151
910	626
911	914
912	103
913	849
913	1288
914	979
915	149
915	294
915	765
915	959
915	1156
916	1231
917	1242
918	944
918	1334
919	919
919	1058
920	1193
921	850
922	1099
923	675
924	1246
925	265
925	294
926	209
927	246
928	963
929	963
930	548
930	636
931	418
931	1241
931	1199
932	182
933	773
934	73
934	330
934	920
935	279
935	421
935	1313
936	722
937	1082
938	1173
939	784
939	1174
940	930
941	398
942	118
942	989
942	1332
943	519
943	898
944	614
944	1127
945	120
946	871
947	219
947	1265
948	715
948	946
948	1121
949	69
950	503
950	808
951	42
951	272
952	1092
953	820
953	887
954	1175
955	856
956	1283
957	844
958	358
958	1337
959	319
960	869
961	1194
961	1195
962	691
962	744
963	963
964	183
965	530
966	35
966	1271
967	987
968	873
968	1139
968	1219
969	462
970	1279
971	294
971	1059
971	1328
972	132
972	605
973	277
973	327
974	46
974	662
974	952
974	1030
975	608
975	1253
975	1338
976	1350
977	532
978	283
978	422
979	141
979	508
979	509
979	585
980	1234
981	13
982	240
982	399
983	586
984	868
985	596
985	1013
985	1060
986	391
986	708
986	1029
987	300
987	937
988	1324
989	541
989	1196
990	615
990	1214
991	461
992	1087
993	43
993	383
994	1170
994	1351
995	496
996	74
997	224
997	575
997	774
998	335
999	851
999	947
999	1072
1000	191
1001	973
1002	76
1002	1017
1003	284
1003	520
1003	1274
1004	656
1004	948
1005	87
1006	408
1007	19
1008	1088
1009	514
1009	647
1009	733
1009	936
1010	86
1010	665
1011	139
1012	1002
1014	198
1015	551
1015	611
1016	912
1016	1028
1017	47
1017	1221
1018	50
1019	894
1020	1007
1021	14
1021	134
1022	999
1023	823
1023	852
1024	856
1025	1371
1026	1032
1027	267
1028	195
1028	659
1028	750
1028	974
1028	975
1028	1186
1029	576
1029	702
1030	616
1031	273
1032	985
1033	153
1034	780
1034	1296
1035	890
1036	985
1037	1254
1038	439
1038	1047
1039	5
1039	209
1039	799
1040	20
1040	444
1040	703
1041	76
1042	400
1043	88
1044	1241
1045	205
1045	1280
1046	1034
1046	1090
1046	1197
1047	21
1047	1214
1048	1374
1049	874
1050	963
1051	681
1052	126
1052	1166
1053	1223
1054	445
1055	699
1055	888
1056	411
1057	490
1057	925
1057	1128
1058	55
1058	80
1059	1132
1060	9
1060	1209
1061	876
1062	740
1063	89
1063	107
1063	140
1063	363
1064	71
1064	446
1065	1077
1066	327
1067	388
1067	557
1067	1046
1067	1353
1068	856
1069	1132
1070	423
1070	891
1071	956
1071	1269
1072	36
1073	454
1073	1203
1074	199
1075	1019
1076	327
1077	597
1078	202
1078	617
1079	1002
1080	225
1081	172
1081	184
1081	391
1082	832
1082	1384
1083	717
1084	291
1085	331
1086	25
1086	311
1086	439
1087	234
1088	150
1088	1272
1089	153
1089	1255
1090	853
1091	235
1092	1215
1093	217
1093	1297
1094	182
1095	75
1096	368
1097	963
1098	475
1098	504
1099	65
1099	568
1100	1197
1101	461
1102	162
1103	856
1104	226
1104	481
1105	274
1105	865
1105	1040
1105	1129
1105	1177
1105	1385
1106	600
1106	718
1107	250
1107	1061
1108	839
1108	1377
1109	127
1109	1179
1110	1197
1111	146
1111	992
1111	1148
1112	292
1113	364
1114	311
1114	1356
1115	401
1116	610
1117	93
1117	369
1118	27
1119	203
1119	1000
1120	552
1120	1093
1120	1269
1121	79
1121	821
1121	1269
1122	497
1123	1298
1124	175
1125	511
1125	969
1125	1140
1126	108
1126	498
1126	582
1126	583
1127	258
1128	204
1128	1230
1129	1117
1130	128
1130	301
1131	439
1131	1386
1132	853
1133	577
1133	1040
1133	1221
1134	889
1135	709
1135	1170
1136	963
1137	751
1138	219
1139	1224
1140	128
1140	301
1141	720
1142	542
1143	698
1143	1048
1144	359
1145	953
1145	1020
1146	1000
1146	1319
1147	236
1147	931
1148	717
1149	196
1149	569
1149	714
1150	300
1150	392
1150	1387
1151	1388
1152	895
1153	1371
1154	196
1154	569
1155	323
1155	792
1156	1266
1157	525
1157	926
1158	1241
1159	692
1159	1031
1159	1248
1160	1003
1161	377
1162	971
1163	26
1163	110
1163	1014
1164	327
1164	460
1164	1004
1165	51
1165	491
1165	515
1165	1005
1166	336
1167	927
1168	989
1169	1156
1170	81
1171	1008
1172	866
1173	854
1174	63
1175	192
1175	438
1175	758
1176	484
1176	1078
1176	1227
1177	570
1177	1333
1178	1361
1179	600
1179	619
1179	1133
1180	1290
1181	162
1182	384
1182	1204
1183	988
1184	481
1185	308
1185	775
1186	337
1187	64
1187	516
1188	1044
1189	467
1189	815
1190	1324
1191	268
1191	574
1191	1025
1191	1387
1192	378
1192	993
1193	135
1193	324
1193	438
1193	758
1194	553
1195	109
1196	21
1196	903
1196	1214
1197	759
1197	785
1197	1320
1198	996
1199	15
1199	275
1199	1035
1199	1112
1200	142
1201	682
1201	1167
1202	72
1202	467
1203	735
1205	1205
1206	429
1206	627
1206	1134
1207	1221
1208	734
1209	760
1210	476
1211	447
1212	791
1213	303
1213	634
1214	856
1215	270
1217	267
1217	1228
1218	1279
1219	154
1219	210
1219	967
1220	746
1221	208
1221	1033
1222	856
1223	56
1223	308
1223	385
1223	485
1223	775
1224	237
1224	879
1225	1283
1226	600
1226	860
1226	1362
\.


--
-- Data for Name: book_genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book_genres (book_id, genre_id) FROM stdin;
1	53
1	61
2	8
2	64
3	53
3	63
3	64
4	53
4	61
4	63
4	64
5	53
6	8
7	1
7	53
7	55
7	63
7	64
8	53
8	55
8	63
8	64
10	8
10	64
11	53
11	63
12	53
12	61
12	63
12	64
13	37
13	55
13	63
13	64
14	28
15	64
16	53
16	64
16	67
16	68
17	64
18	53
18	55
19	53
19	61
19	64
20	53
20	55
20	64
21	44
21	53
21	61
21	64
24	53
24	55
24	63
24	64
24	67
25	53
25	55
25	61
25	63
26	55
27	53
27	63
28	53
28	55
28	61
28	63
28	64
30	63
30	64
31	53
31	55
31	61
31	63
31	64
32	53
32	63
34	53
35	33
35	53
35	63
36	64
37	53
37	64
41	1
41	53
41	64
42	1
42	55
43	44
44	55
44	64
45	64
46	55
46	64
47	61
48	3
48	53
48	63
48	64
49	53
49	55
50	53
50	55
50	61
50	63
50	64
51	19
51	53
51	55
52	53
52	55
52	63
81	53
81	63
81	64
82	53
82	63
82	64
102	53
102	61
102	64
103	53
103	55
103	64
104	64
105	53
105	64
106	53
106	61
106	63
106	64
107	55
107	63
108	55
108	64
109	53
109	61
109	63
109	64
110	53
111	53
111	63
111	64
112	53
112	64
113	64
114	53
114	55
114	61
114	63
114	64
115	53
115	55
115	63
115	64
116	53
116	64
117	53
118	53
118	55
118	64
119	53
119	61
119	63
119	64
120	16
120	53
120	61
121	53
121	63
121	64
122	53
122	64
123	64
124	53
124	55
124	64
125	53
125	55
125	63
125	64
125	68
126	67
126	68
127	3
127	8
128	3
128	53
129	53
129	61
129	63
129	64
130	7
130	55
131	8
131	55
131	64
133	8
133	48
136	53
136	63
137	16
137	53
137	55
137	63
138	55
138	63
140	64
141	53
141	63
141	64
142	53
143	53
143	63
144	53
144	61
144	64
145	16
145	53
145	55
145	61
145	64
146	53
146	63
147	53
147	55
147	63
147	64
148	43
148	53
149	7
149	16
149	53
149	55
149	64
150	53
150	61
150	64
151	53
151	64
153	17
153	36
154	44
154	53
154	63
154	64
155	64
156	53
156	61
156	63
156	64
157	6
157	61
157	64
158	64
159	53
159	61
160	3
160	53
161	15
161	53
161	56
162	55
163	53
163	55
165	8
166	53
166	55
166	61
166	64
167	16
167	53
167	55
167	63
167	64
167	68
168	53
168	55
168	64
168	68
169	16
169	53
169	64
170	48
172	53
172	61
172	63
172	64
174	37
174	53
174	61
174	64
176	3
177	64
178	63
178	64
179	53
179	61
179	64
179	67
180	53
180	55
180	64
181	53
181	61
181	63
181	64
182	16
182	53
182	64
183	64
184	53
184	55
184	63
185	55
185	63
185	64
186	64
187	4
187	64
188	64
189	53
189	55
189	63
189	64
191	55
191	63
191	64
192	53
192	54
193	53
193	64
195	64
196	6
196	53
196	61
196	63
196	64
197	28
197	64
198	3
198	53
198	63
198	64
199	53
200	53
200	55
200	64
201	53
201	61
201	63
205	30
205	64
206	53
206	63
206	64
223	6
223	53
223	61
223	64
224	3
224	53
224	55
225	53
225	64
239	53
239	63
239	64
240	53
240	64
241	53
241	63
241	64
242	3
242	53
242	61
242	64
243	3
244	47
244	64
245	28
245	64
246	64
247	8
247	53
247	64
248	53
248	55
248	64
249	52
250	16
250	53
250	61
250	64
251	32
251	64
252	53
252	64
253	8
253	64
254	64
255	1
255	7
255	55
255	68
256	3
256	53
257	53
257	55
257	63
257	64
258	8
258	53
259	53
259	61
259	64
260	64
260	67
261	37
261	53
261	55
261	64
262	53
262	61
262	64
263	53
264	53
264	63
264	64
265	53
265	55
265	63
266	44
266	64
267	53
267	55
268	44
268	53
268	55
268	61
268	63
268	64
269	8
269	64
271	8
272	52
272	53
272	61
272	63
273	44
273	53
273	55
273	61
273	64
274	53
274	61
274	63
274	64
275	53
275	55
275	61
275	63
275	64
276	16
276	53
276	64
277	53
277	55
277	63
277	64
278	53
278	55
278	61
278	63
279	3
279	53
279	63
279	64
280	8
280	53
280	63
282	39
282	47
284	43
284	53
285	53
285	55
285	61
285	63
286	53
288	53
288	54
288	64
289	3
289	53
289	55
289	63
290	1
290	55
290	64
291	53
291	54
292	16
292	37
292	53
292	55
292	61
292	63
292	64
293	53
293	55
293	63
295	1
295	53
295	55
295	63
295	64
296	53
296	61
296	63
296	64
297	6
297	53
297	61
297	64
298	53
298	55
298	63
299	53
299	55
300	5
300	64
301	53
302	64
303	54
304	53
304	61
304	63
304	64
305	53
305	55
305	61
305	63
306	53
306	63
307	64
308	55
309	53
312	53
312	55
312	61
312	63
312	64
313	53
313	55
313	63
313	64
314	53
314	55
314	63
314	64
315	1
315	53
315	55
316	64
317	37
317	63
317	64
318	64
319	44
319	61
320	53
320	61
320	63
321	53
321	55
321	61
321	63
321	64
322	53
323	8
323	53
323	63
324	53
324	61
325	8
325	53
326	53
326	61
326	64
327	53
327	55
327	63
327	64
328	53
328	55
328	64
329	6
329	53
329	55
329	61
329	63
329	64
330	64
331	53
331	63
331	64
332	53
332	55
333	8
333	53
333	61
333	64
334	63
334	64
335	53
335	55
335	63
336	53
336	61
336	63
336	64
337	55
339	43
341	53
341	55
341	64
342	53
342	64
343	53
343	61
343	63
344	1
346	53
346	64
346	67
346	68
347	37
347	64
348	16
348	35
348	53
348	55
348	64
349	8
349	53
350	53
350	61
350	64
351	55
352	53
352	55
354	1
354	55
354	63
355	53
355	61
356	53
357	52
357	53
357	55
358	64
359	53
359	55
359	64
359	67
359	68
360	30
360	53
360	64
361	63
361	64
362	53
362	55
362	64
363	8
363	53
364	64
365	53
365	61
365	63
365	64
366	53
366	55
366	63
366	64
366	68
367	53
367	55
367	63
367	64
367	67
367	68
368	1
368	53
368	55
368	64
369	53
369	55
369	63
369	64
370	53
370	54
370	63
371	52
371	53
371	55
371	61
371	63
371	64
372	3
372	8
372	53
372	63
372	64
373	8
373	53
373	55
374	64
375	8
375	13
375	64
376	8
376	53
376	63
377	53
377	61
377	63
377	64
378	53
378	64
379	53
380	52
381	1
381	55
381	61
381	64
382	53
382	61
382	64
383	29
383	31
384	53
385	53
385	61
385	63
386	32
386	64
388	6
388	53
388	64
389	1
389	55
390	53
390	61
390	63
390	64
390	67
391	53
392	53
392	61
392	64
394	55
395	3
395	53
395	55
396	3
396	53
397	55
397	64
399	53
399	63
399	64
400	53
400	61
401	53
401	63
401	64
402	53
402	63
403	53
403	55
403	64
404	16
404	53
404	61
404	64
405	53
405	55
405	64
406	44
406	53
406	61
406	63
406	64
407	37
407	53
407	55
407	63
407	64
408	16
408	53
408	55
408	61
408	63
408	64
409	53
409	61
410	53
410	63
410	64
410	67
411	53
411	61
411	64
412	53
412	55
413	53
413	63
413	64
414	48
415	53
415	55
415	61
417	6
417	53
417	55
417	61
417	63
417	64
417	67
418	53
418	55
418	63
419	16
419	53
419	55
419	63
419	64
420	55
421	53
421	55
421	63
421	64
422	53
422	63
422	64
423	55
423	63
424	53
424	55
424	63
425	53
425	61
426	53
426	63
426	64
427	53
427	55
427	61
427	63
428	53
428	63
428	64
429	44
429	53
429	64
430	53
431	53
431	55
431	61
431	63
431	64
431	67
431	68
432	55
433	8
433	64
434	52
435	53
435	63
436	53
436	55
436	63
436	64
436	67
436	68
437	55
438	53
438	61
438	64
439	55
439	63
439	64
440	53
440	54
440	55
440	61
440	63
440	64
440	67
441	53
441	61
441	63
441	64
442	24
442	31
443	52
443	53
443	55
444	3
444	64
445	64
446	3
446	53
446	55
447	6
447	53
447	61
447	64
449	53
449	63
450	53
450	63
450	64
450	67
451	53
451	64
452	53
452	55
453	53
453	55
454	53
454	55
454	63
455	53
455	55
455	63
455	64
455	67
456	3
456	53
456	55
456	64
457	53
457	61
457	63
457	64
458	6
458	53
458	61
458	63
459	53
459	61
460	6
460	61
460	64
461	53
461	61
461	63
462	53
462	64
463	16
463	53
463	55
463	64
464	6
464	53
464	61
464	64
465	53
465	63
465	64
466	53
466	55
466	61
466	63
466	64
467	64
468	8
468	53
470	64
471	37
471	53
471	64
472	63
473	64
474	53
474	61
474	63
474	64
476	53
476	54
476	63
476	64
477	53
477	55
477	63
477	64
477	67
478	55
479	44
479	61
479	64
481	53
481	63
482	53
482	55
482	63
482	64
483	53
485	53
485	55
485	61
485	63
485	64
486	44
487	44
487	53
487	55
487	61
487	63
487	64
488	8
488	53
488	64
489	37
489	64
490	53
490	63
490	64
491	3
491	53
493	16
493	53
493	63
493	64
495	53
495	55
495	64
496	53
496	61
497	53
497	61
497	63
497	64
498	53
498	63
498	64
499	53
499	55
499	64
500	53
501	8
502	53
502	63
503	16
503	53
503	61
504	6
504	53
504	64
505	16
505	53
505	55
505	63
505	64
505	67
505	68
506	16
506	53
506	61
506	63
506	64
507	53
507	61
507	63
507	64
508	65
508	67
508	68
509	53
509	61
509	63
509	64
510	53
510	61
510	64
511	3
511	53
511	54
511	55
511	63
512	44
512	53
512	63
513	53
513	61
513	63
513	64
514	16
514	53
514	55
514	61
514	63
514	64
515	3
515	16
515	53
515	55
515	61
515	63
515	64
516	3
516	53
517	53
517	63
518	63
519	8
520	8
521	53
522	8
522	33
522	53
522	55
522	61
522	63
522	64
523	53
523	55
523	64
524	32
524	53
524	64
525	26
525	52
525	55
525	63
525	64
526	6
527	53
527	64
528	37
528	64
529	53
529	61
529	63
529	64
530	16
530	53
530	64
531	64
532	47
532	64
533	14
533	16
533	64
534	16
534	53
534	61
534	63
534	64
535	53
535	64
536	6
536	53
536	63
536	64
537	53
537	61
537	63
537	64
538	53
538	64
539	16
539	53
539	61
539	63
539	64
540	8
540	28
540	64
541	1
541	53
541	55
541	64
542	53
542	64
543	14
544	53
544	61
544	63
544	64
545	16
545	53
545	61
545	63
545	64
545	67
546	64
547	6
547	53
547	61
547	63
548	44
548	61
549	53
549	61
550	53
550	55
550	63
550	64
551	53
551	64
552	3
552	53
552	64
553	53
554	64
555	53
555	55
555	63
555	64
556	53
556	55
556	63
556	64
558	16
558	37
558	53
558	55
558	61
558	63
558	64
559	53
560	53
560	63
560	64
561	37
561	53
563	64
564	53
564	55
565	37
565	53
565	63
565	64
567	32
568	64
569	53
569	61
569	64
570	64
571	37
571	53
571	64
572	1
572	53
572	55
572	63
572	64
573	53
573	55
573	64
574	53
574	61
574	63
574	64
595	1
596	53
596	63
596	64
597	53
597	61
597	63
597	64
598	44
598	53
598	61
598	64
628	53
628	55
628	61
628	63
628	64
629	44
629	64
630	44
630	53
630	64
631	53
631	55
631	64
632	53
632	61
633	28
633	44
633	50
633	64
634	53
635	53
635	63
636	63
636	64
636	68
637	8
637	64
638	53
639	53
639	55
639	61
639	63
639	64
640	53
640	55
640	63
641	53
641	63
641	64
642	53
642	55
643	53
643	55
643	61
643	63
643	64
644	53
644	55
644	63
644	64
644	67
644	68
645	53
645	55
645	63
646	53
646	55
646	63
647	44
647	53
647	64
648	53
648	64
648	67
649	53
649	64
650	55
650	64
651	61
651	63
651	64
652	53
653	44
653	53
654	64
655	53
655	64
656	53
656	64
657	53
657	61
657	63
657	64
658	53
658	55
658	63
658	64
659	53
659	63
659	64
660	43
660	53
661	53
661	54
661	64
662	1
662	53
662	55
662	61
662	63
662	64
663	53
663	64
664	53
664	55
664	61
664	63
664	64
665	53
665	55
665	63
666	53
666	55
666	63
666	64
666	67
667	3
667	53
668	53
668	61
668	63
669	53
669	61
670	53
670	63
671	55
671	61
672	8
672	64
673	44
673	53
673	61
673	63
674	53
674	55
674	63
674	64
674	67
675	8
675	64
676	1
676	2
676	55
676	63
677	14
677	16
678	30
678	64
679	53
679	55
679	64
680	52
681	6
681	53
681	61
681	63
681	64
682	53
682	55
682	63
683	7
683	55
684	8
684	53
684	63
684	64
685	32
685	64
686	53
686	55
686	63
686	64
687	53
687	55
687	64
688	53
688	61
689	53
689	61
689	63
689	64
690	64
691	64
692	16
692	53
692	61
692	64
693	64
694	53
694	63
695	6
695	16
695	53
695	61
695	63
695	64
696	6
696	53
696	61
696	64
697	53
697	55
697	63
697	64
698	53
698	55
699	44
699	53
699	64
701	6
701	53
701	61
701	63
701	64
702	37
702	55
702	64
703	16
703	53
703	55
703	61
703	63
703	64
704	3
704	53
704	61
704	64
705	37
705	55
705	64
706	53
706	55
706	63
706	67
707	53
707	61
709	53
710	53
710	64
711	53
711	55
712	53
712	63
712	64
713	53
713	61
713	63
713	64
714	1
714	53
714	55
714	64
715	64
716	53
716	63
716	64
717	55
717	64
718	64
719	53
719	55
719	63
719	64
720	53
720	61
720	63
720	64
721	53
721	63
722	53
722	55
722	63
722	64
723	16
723	53
723	55
723	61
723	63
723	64
724	53
724	55
724	63
725	3
725	53
726	53
727	53
728	53
728	61
728	64
729	53
729	64
730	53
730	55
730	61
731	53
731	55
731	61
731	64
732	8
732	53
732	55
733	53
733	55
733	63
734	44
734	53
734	61
735	53
735	61
735	63
735	64
736	3
736	53
736	55
736	61
736	64
737	53
737	63
737	64
738	53
738	55
738	63
738	64
739	53
739	55
739	63
739	64
740	53
741	30
741	64
742	37
742	55
742	64
743	8
743	53
743	64
744	3
744	16
744	53
744	64
745	52
746	53
746	61
746	63
746	64
747	16
747	53
748	53
748	61
748	63
748	64
749	64
750	53
750	63
750	64
751	53
751	54
751	55
751	64
752	53
752	61
752	63
752	64
753	53
754	3
754	16
754	53
754	61
754	63
754	64
755	16
755	53
755	63
755	64
756	53
756	55
756	61
756	63
756	64
757	53
757	61
757	63
757	64
758	37
758	55
758	63
758	64
759	53
759	63
759	64
760	16
760	53
760	63
760	64
761	53
761	61
761	64
762	53
762	61
762	64
763	53
763	64
764	53
764	61
764	63
765	53
765	55
765	63
765	64
766	53
766	64
767	53
767	63
768	53
768	61
768	63
768	64
769	53
769	55
769	63
769	64
770	3
770	53
770	55
771	64
772	8
772	55
773	53
773	64
774	16
774	53
774	61
774	63
774	64
774	67
775	37
775	64
776	43
776	55
777	16
777	53
777	61
777	63
777	64
778	64
779	37
779	64
780	16
780	53
780	55
780	61
780	63
780	64
781	53
781	63
781	64
782	16
782	53
782	55
782	63
782	64
783	53
783	61
783	64
784	53
784	55
784	63
784	64
785	43
786	64
787	53
787	63
787	64
788	1
788	16
788	53
788	55
788	64
789	44
789	53
789	61
790	53
790	63
791	53
791	55
791	63
792	53
792	61
792	63
792	64
793	53
793	55
794	53
794	61
794	64
795	53
795	55
795	61
795	64
796	7
796	16
796	53
796	55
797	53
797	65
797	67
798	53
798	55
799	53
799	55
799	61
799	63
799	64
800	53
800	54
800	55
800	61
800	64
801	53
802	55
802	64
803	53
803	55
805	36
805	45
805	53
805	55
806	1
806	3
806	53
806	63
807	53
807	64
808	65
809	8
809	63
810	31
811	53
811	61
811	63
811	64
813	3
814	8
815	55
815	63
816	53
816	55
816	64
817	53
817	55
817	61
817	63
817	64
818	8
818	53
818	64
819	3
819	53
819	55
819	63
819	64
820	55
820	64
821	53
821	61
822	53
822	61
822	63
822	64
823	64
824	64
825	53
825	61
825	63
826	53
826	61
827	64
828	53
828	55
828	63
829	3
829	53
830	53
831	28
832	53
832	61
832	63
833	53
833	63
833	64
834	16
834	53
834	64
835	53
835	64
836	53
836	63
836	64
837	53
837	63
837	64
839	53
839	63
839	64
840	53
840	55
840	63
840	64
841	53
843	53
843	55
843	61
843	63
843	64
844	52
845	55
845	63
846	16
846	53
846	55
846	61
846	63
846	64
847	64
848	53
848	61
848	64
849	53
849	64
850	64
851	53
851	61
851	63
851	64
852	53
852	55
853	53
853	61
853	63
853	64
854	53
854	61
854	63
854	64
855	17
855	36
855	43
857	53
857	55
857	61
857	63
858	16
858	53
858	61
858	63
858	64
859	53
859	61
859	63
859	64
860	53
860	55
860	63
860	64
861	37
862	53
862	54
863	53
863	55
863	64
864	3
864	53
865	44
865	53
865	61
865	63
865	64
867	1
867	3
867	53
868	53
868	55
868	63
868	64
869	53
869	55
869	63
870	1
870	3
870	53
870	55
870	61
870	63
870	64
872	53
872	64
874	16
874	53
874	55
874	61
874	63
874	64
875	53
875	61
875	64
876	53
876	54
876	63
877	44
877	53
877	55
877	61
877	63
877	64
878	53
878	61
878	63
878	64
879	53
879	54
880	44
880	53
880	64
881	8
881	48
881	53
881	55
881	63
882	47
882	64
883	53
883	55
883	61
883	63
884	6
884	53
884	61
884	64
885	22
885	31
886	53
886	55
886	64
887	8
887	53
888	53
888	61
888	63
888	64
889	53
889	61
889	63
890	53
890	64
891	55
891	63
892	53
892	55
892	61
892	63
892	64
893	3
893	53
893	55
894	3
894	53
894	55
894	63
895	3
895	53
896	3
896	53
897	53
897	61
897	63
897	64
898	53
899	53
899	61
899	63
899	64
900	53
901	32
901	64
902	8
902	64
903	53
903	61
903	63
903	64
904	44
905	64
906	18
907	64
908	53
908	61
908	64
909	53
909	63
909	64
910	53
910	61
910	63
910	64
911	37
911	53
911	55
911	64
912	28
912	44
913	53
913	63
913	64
914	53
914	61
914	63
914	64
915	53
915	55
915	63
916	8
916	53
916	64
917	1
917	55
918	53
918	54
918	55
918	61
918	63
918	64
919	52
919	53
919	63
920	43
920	53
921	53
921	63
921	64
922	53
922	55
923	8
923	53
923	63
924	8
925	53
925	55
925	61
925	63
925	64
926	53
926	64
927	53
927	61
927	63
928	53
928	63
928	64
929	53
929	63
929	64
930	53
930	61
930	63
930	64
931	53
931	55
931	63
932	53
932	61
932	64
933	64
934	53
934	61
934	63
934	64
935	37
935	55
935	63
936	55
936	64
937	53
937	54
937	63
937	64
938	28
938	53
938	64
939	16
939	53
939	55
939	61
939	63
939	64
940	1
940	63
941	53
941	61
941	64
942	53
942	55
942	63
942	64
943	3
943	53
944	37
944	53
944	64
945	8
945	53
945	63
945	64
946	16
946	53
946	63
946	64
947	53
947	63
947	64
948	37
948	53
948	63
949	53
949	61
949	64
950	43
950	53
950	55
950	64
951	55
952	53
952	63
952	64
953	53
953	61
953	63
953	64
953	67
954	53
954	61
954	63
954	64
955	53
955	61
955	63
956	53
956	55
956	64
957	16
957	53
957	61
957	63
957	64
958	53
959	53
959	64
960	32
960	64
961	53
961	61
961	64
962	53
962	55
962	63
962	64
963	53
963	63
963	64
964	53
964	55
965	53
965	61
965	63
965	64
967	53
967	54
968	53
968	55
968	63
968	64
969	29
969	31
969	53
969	64
970	64
971	53
971	55
971	63
971	64
972	53
972	63
972	64
973	6
973	53
973	61
973	63
973	64
974	53
974	55
974	63
974	64
975	16
975	53
975	55
975	61
975	63
975	64
976	37
976	64
977	3
977	16
977	26
977	53
977	64
978	64
979	53
979	63
979	64
980	64
980	66
981	53
981	61
981	63
981	64
982	43
982	53
983	16
983	53
983	55
983	63
983	64
984	53
984	64
985	53
985	55
985	61
986	53
986	61
986	63
986	64
987	53
987	55
987	61
987	63
987	64
988	53
988	55
989	16
989	53
989	55
989	61
989	63
989	64
990	37
990	63
990	64
991	53
991	55
991	61
991	63
991	64
992	53
992	61
992	63
992	64
993	64
994	53
994	61
994	63
994	64
995	17
995	36
996	64
997	53
997	61
997	63
997	64
998	44
998	53
998	64
999	8
999	55
1000	53
1000	63
1000	64
1000	67
1001	53
1001	61
1001	64
1002	53
1002	63
1003	63
1004	53
1005	64
1006	53
1006	54
1006	63
1006	64
1007	64
1008	53
1008	61
1008	63
1008	64
1009	53
1010	53
1010	55
1010	61
1010	63
1010	64
1010	68
1011	53
1011	63
1011	64
1012	16
1012	53
1012	55
1012	63
1014	16
1014	53
1014	55
1014	63
1014	64
1015	53
1015	61
1015	64
1016	53
1016	55
1016	61
1016	63
1016	64
1017	53
1017	61
1017	63
1017	64
1019	53
1020	3
1020	53
1020	63
1020	64
1021	53
1021	63
1021	64
1023	8
1024	53
1024	64
1025	44
1025	53
1025	61
1025	64
1026	53
1026	55
1027	53
1027	55
1027	64
1028	53
1028	61
1028	63
1029	53
1029	55
1029	64
1030	8
1030	53
1031	53
1031	61
1031	63
1031	64
1032	53
1032	61
1032	63
1032	64
1033	8
1033	53
1034	44
1034	64
1035	6
1035	53
1035	61
1035	63
1035	64
1036	53
1036	64
1037	53
1037	64
1038	53
1039	53
1040	43
1040	53
1040	55
1041	3
1041	53
1041	63
1042	37
1042	53
1042	55
1042	63
1043	55
1044	53
1044	61
1044	63
1045	53
1045	64
1046	53
1046	55
1046	61
1046	63
1046	64
1047	37
1047	64
1048	8
1048	64
1049	8
1049	63
1050	16
1050	53
1050	63
1050	64
1051	3
1051	55
1051	64
1052	8
1052	64
1053	8
1053	64
1054	64
1055	8
1055	43
1055	64
1056	43
1057	53
1057	64
1058	14
1058	29
1058	31
1058	53
1058	64
1060	53
1060	55
1060	61
1060	63
1060	64
1061	53
1061	64
1062	44
1062	53
1062	61
1062	64
1063	37
1063	55
1063	63
1064	53
1064	63
1064	64
1065	64
1066	53
1066	61
1066	63
1066	64
1067	53
1067	55
1067	63
1068	56
1068	64
1069	53
1069	63
1069	64
1070	52
1071	53
1071	63
1072	53
1072	61
1072	64
1073	8
1073	53
1073	64
1075	16
1075	19
1075	53
1075	54
1075	61
1075	63
1075	64
1076	53
1076	55
1076	61
1076	63
1076	64
1077	53
1077	55
1077	63
1077	64
1078	8
1079	53
1079	55
1079	63
1080	33
1080	53
1080	55
1080	63
1080	64
1080	66
1081	3
1081	53
1081	63
1081	64
1082	53
1082	55
1083	22
1083	31
1084	53
1084	55
1084	61
1084	63
1084	64
1085	16
1085	53
1085	63
1086	3
1086	53
1087	53
1087	64
1088	26
1088	52
1088	53
1089	52
1090	64
1091	53
1091	63
1091	64
1092	53
1092	61
1092	63
1092	64
1093	16
1093	53
1093	61
1093	63
1093	64
1094	53
1094	64
1096	33
1096	53
1096	63
1097	53
1097	61
1097	63
1097	64
1098	8
1099	16
1099	53
1099	64
1100	64
1101	53
1101	63
1101	64
1102	16
1102	53
1102	64
1102	68
1103	3
1103	53
1103	55
1103	61
1104	53
1104	61
1104	63
1104	64
1105	53
1105	55
1105	63
1105	64
1106	55
1107	1
1107	53
1107	55
1107	63
1108	53
1108	61
1108	63
1108	64
1109	8
1109	48
1109	64
1110	64
1111	6
1111	53
1111	55
1111	61
1111	63
1111	64
1112	53
1112	64
1113	53
1113	55
1113	63
1114	53
1114	55
1114	64
1115	53
1115	64
1116	3
1116	53
1116	55
1117	55
1117	64
1118	53
1118	55
1118	63
1118	64
1119	3
1119	53
1119	61
1119	63
1119	64
1120	43
1120	53
1120	54
1120	55
1120	61
1120	63
1120	64
1121	53
1121	54
1121	64
1122	3
1122	53
1122	55
1122	63
1123	53
1123	55
1123	63
1123	64
1124	16
1124	53
1124	55
1124	61
1124	63
1124	64
1125	53
1125	55
1125	61
1125	63
1125	64
1126	53
1126	55
1126	63
1127	1
1127	53
1127	55
1127	63
1127	64
1128	53
1128	54
1128	55
1128	61
1128	63
1128	64
1129	16
1129	53
1129	55
1129	61
1129	63
1129	64
1130	1
1130	53
1130	55
1130	61
1130	63
1130	64
1131	53
1131	55
1131	63
1131	64
1132	8
1132	48
1132	64
1133	53
1133	55
1133	61
1133	64
1134	64
1135	16
1135	53
1135	64
1136	16
1136	53
1136	63
1136	64
1137	53
1137	61
1137	63
1137	64
1138	64
1139	53
1139	63
1139	64
1140	1
1140	53
1140	55
1140	63
1140	64
1141	53
1141	61
1141	63
1141	64
1142	53
1142	64
1143	53
1143	55
1143	63
1143	64
1144	53
1144	64
1145	53
1145	61
1145	63
1145	64
1146	16
1146	53
1146	55
1146	61
1146	63
1146	64
1147	53
1147	55
1147	64
1148	64
1149	53
1150	53
1150	55
1150	63
1151	52
1152	8
1152	53
1152	63
1153	44
1153	53
1153	61
1153	63
1153	64
1154	42
1154	53
1154	55
1155	53
1155	61
1156	16
1156	53
1156	63
1156	64
1157	64
1158	53
1158	55
1158	61
1158	63
1159	53
1159	55
1159	64
1160	3
1160	53
1161	53
1161	64
1162	53
1162	63
1162	64
1163	53
1163	55
1163	61
1163	63
1163	64
1164	53
1164	61
1164	63
1164	64
1165	53
1165	63
1165	64
1166	53
1166	55
1166	61
1166	63
1166	64
1167	53
1167	63
1167	64
1168	53
1168	55
1168	63
1168	64
1169	53
1169	55
1169	63
1169	64
1170	53
1170	55
1170	64
1171	53
1171	63
1171	64
1173	64
1174	64
1176	48
1176	64
1177	6
1177	53
1177	61
1177	63
1177	64
1178	53
1178	61
1178	63
1178	64
1179	53
1179	55
1180	53
1180	64
1181	16
1181	53
1181	55
1181	63
1181	64
1181	67
1181	68
1182	1
1182	8
1182	42
1182	53
1182	55
1183	8
1183	53
1183	64
1184	53
1184	61
1184	63
1184	64
1185	53
1185	64
1186	53
1186	55
1186	63
1188	53
1188	55
1188	63
1188	64
1189	53
1189	55
1189	61
1189	63
1189	64
1190	1
1190	53
1190	55
1190	63
1191	16
1191	53
1191	55
1191	61
1191	63
1191	64
1192	53
1192	61
1192	64
1193	53
1194	53
1194	61
1194	64
1195	53
1195	61
1195	63
1195	64
1196	64
1197	42
1197	53
1197	55
1197	63
1198	16
1198	53
1198	55
1198	61
1198	63
1199	1
1199	55
1199	63
1199	64
1200	16
1200	53
1200	55
1200	61
1200	63
1200	64
1201	1
1201	53
1201	55
1201	63
1201	64
1202	53
1202	61
1202	63
1202	64
1203	53
1203	61
1203	64
1205	37
1205	53
1205	55
1205	61
1205	63
1205	64
1206	53
1206	55
1206	61
1206	63
1206	64
1207	53
1207	64
1208	16
1208	53
1208	54
1208	61
1208	63
1208	64
1209	53
1209	61
1209	63
1209	64
1210	8
1210	53
1210	63
1210	64
1211	37
1211	53
1211	64
1212	8
1212	53
1212	63
1213	44
1213	53
1213	61
1213	64
1214	3
1214	53
1214	55
1214	63
1215	16
1215	53
1215	63
1215	64
1217	53
1217	55
1217	64
1218	64
1219	8
1219	53
1220	53
1220	63
1220	64
1221	3
1221	53
1221	55
1221	64
1222	3
1222	53
1222	55
1222	61
1222	63
1222	64
1223	53
1223	55
1223	61
1223	63
1223	64
1224	53
1224	61
1224	63
1224	64
1225	53
1225	55
1225	63
1225	64
1226	3
1226	53
1226	61
1226	64
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (book_id, title, total_pages, rating, published_date, isbn) FROM stdin;
1	Lean Software Development: An Agile Toolkit	240	4.17	2003-05-18	9780320000000
2	Facing the Intelligence Explosion	91	3.87	2013-02-01	\N
3	Scala in Action	419	3.74	2013-04-10	9781940000000
4	Patterns of Software: Tales from the Software Community	256	3.84	1996-08-15	9780200000000
5	Anatomy Of LISP	446	4.43	1978-01-01	9780070000000
6	Computing machinery and intelligence	24	4.17	2009-03-22	\N
7	XML: Visual QuickStart Guide	269	3.66	2009-01-01	9780320000000
8	SQL Cookbook	595	3.95	2005-12-01	9780600000000
9	The Apollo Guidance Computer: Architecture And Operation (Springer Praxis Books / Space Exploration)	439	4.29	2010-07-01	9781440000000
10	Minds and Computers: An Introduction to the Philosophy of Artificial Intelligence	222	3.54	2007-02-13	9780750000000
11	The Architecture of Symbolic Computers	739	4.50	1990-11-01	9780070000000
12	Exceptional Ruby: Master the Art of Handling Failure in Ruby	102	4.00	\N	\N
13	Nmap Network Scanning: The Official Nmap Project Guide to Network Discovery and Security Scanning	468	4.32	2009-01-01	9780980000000
14	The It Handbook for Business: Managing Information Technology Support Costs	180	4.40	2010-09-17	9781450000000
15	Accidental Empires	384	4.00	1996-09-13	9780890000000
16	Introducing HTML5	223	3.97	2010-07-21	9780320000000
17	Are You Smart Enough to Work at Google?	290	3.52	2012-01-04	9780320000000
18	Elements of ML Programming, Ml97 Edition	400	3.70	1998-01-01	9780140000000
19	Scrum and XP from the Trenches	140	4.17	2007-10-05	9781430000000
20	What is HTML 5?	27	3.31	\N	\N
21	Becoming a Technical Leader: An Organic Problem-Solving Approach	284	4.09	1986-01-01	9780930000000
22	The Text Mining Handbook: Advanced Approaches in Analyzing Unstructured Data	410	3.95	2013-08-15	9780520000000
23	Constraint Processing	480	3.38	2003-05-19	9781560000000
24	Essential PHP Security	109	4.07	2005-11-01	9780600000000
25	A Book on C: Programming in C	576	3.74	1994-11-01	9780810000000
26	Scientific Computing	576	3.42	2001-07-17	9780070000000
27	Cocoa Design Patterns	427	4.00	2009-09-01	9780320000000
28	Cocoa Programming for Mac OS X	433	3.97	2008-05-05	9780320000000
29	Six Degrees: The Science of a Connected Age	384	3.90	2004-02-17	9780390000000
30	Big Data Now: Current Perspectives from O'Reilly Radar	137	3.33	\N	\N
31	OpenGL Programming Guide: The Official Guide to Learning OpenGL, Version 2	838	3.66	2005-08-11	9780320000000
32	Killer Game Programming in Java	969	3.26	2005-05-30	9780600000000
33	Mathematik Fur Informatiker: Band 1: Diskrete Mathematik Und Lineare Algebra	514	4.10	2010-10-13	9783540000000
34	C++ Network Programming, Volume I: Mastering Complexity with ACE and Patterns	336	3.85	2001-12-20	9780200000000
35	Gamification by Design	208	3.66	2011-08-19	9781450000000
36	Cyberwar: The Next Threat to National Security & What to Do About It	304	3.72	2010-04-20	9780060000000
37	More Effective C#: 50 Specific Ways to Improve Your C#	297	4.09	2008-10-17	9780320000000
41	C++ Programming: From Problem Analysis to Program Design	1344	4.18	2006-02-01	9781420000000
42	Numerical Linear Algebra	184	4.17	1997-06-01	9780900000000
43	The Principles of Product Development Flow: Second Generation Lean Product Development	276	4.16	2009-05-01	9781940000000
44	An Embedded Software Primer	448	3.71	1999-08-15	9780200000000
45	Free Culture: The Nature and Future of Creativity	368	4.12	2005-02-22	9780140000000
46	Upgrading and Repairing PCs	1608	4.13	2006-04-03	9780790000000
47	Perfect Software--And Other Illusions about Testing	182	4.13	2008-01-01	9780930000000
48	Mastering Algorithms with C	562	3.78	1999-08-12	9781570000000
49	Ant: The Definitive Guide	336	3.08	2005-04-20	9780600000000
50	Version Control By Example	\N	3.49	2011-07-22	\N
51	A Primer on Scientific Programming with Python	693	3.85	2009-09-10	9783640000000
52	Practical C++ Programming	574	3.58	2002-12-20	9780600000000
80	Computer Science from the Bottom Up	\N	3.80	\N	\N
81	ZooKeeper: Distributed process coordination	238	3.92	2013-12-02	9781450000000
82	Two Scoops of Django: Best Practices for Django 1.5	277	4.23	2013-01-20	\N
102	Git in Practice	225	4.12	2014-10-31	9781620000000
103	Programming F# 3.0	476	3.86	2012-10-26	9781450000000
104	No Place to Hide: Edward Snowden, the NSA, and the U.S. Surveillance State	260	4.08	2014-05-13	9781630000000
105	Android Design Patterns: Interaction Design Solutions for Developers	456	3.72	2013-03-11	9781120000000
106	The Career Programmer: Guerilla Tactics for an Imperfect World (Expert's Voice)	264	3.15	2006-02-01	9781590000000
107	Principles of Concurrent and Distributed Programming	361	3.44	2006-02-01	9780320000000
108	The Elements of Scrum	184	3.94	2011-03-22	9780980000000
109	Java Se8 for the Really Impatient: A Short Course on the Basics	215	3.92	2014-01-24	9780320000000
110	The Book of F#: Breaking Free with Managed Functional Programming	352	3.88	2014-03-22	9781590000000
111	Good Math: A Geek's Guide to the Beauty of Numbers, Logic, and Computation	262	3.62	2013-09-06	9781940000000
112	Methods of Programming	272	4.08	1988-01-01	9780200000000
113	Principles of Information Security	624	3.42	2008-01-01	9781420000000
114	Learn Windows PowerShell 3 in a Month of Lunches	368	4.30	2012-11-22	9781620000000
115	Professional Android 4 Application Development	817	3.94	2012-05-01	9781120000000
116	Show Stopper,: The Breakneck Race to Create Windows NT and the Next Generation at Microsoft	312	4.12	1994-06-01	9780030000000
117	Explore It,: Reduce Risk and Increase Confidence with Exploratory Testing	162	4.33	2012-03-22	9781940000000
118	The Python Standard Library by Example	672	4.23	2011-06-11	9780320000000
119	JUnit in Action	504	3.54	2010-08-04	9781940000000
120	The Mikado Method	245	3.36	2014-03-22	9781620000000
121	REST API Design Rulebook	116	3.29	\N	\N
122	Scrum: a Breathtakingly Brief and Agile Introduction	54	3.93	2014-07-30	\N
123	Security+ Guide to Network Security Fundamentals	592	3.65	2008-11-11	9781430000000
124	Classic Shell Scripting: Hidden Commands that Unlock the Power of Unix	560	4.03	2005-05-23	9780600000000
125	Head First HTML and CSS	768	4.25	2012-09-05	9780600000000
126	Mobile First	130	3.96	2011-10-18	\N
127	Genetic Algorithms in Search, Optimization, and Machine Learning	432	4.14	1989-01-11	785342000000
128	Introduction to Distributed Algorithms	612	3.73	2004-01-05	9780520000000
129	Debug It,: Find, Repair, and Prevent Bugs in Your Code	232	3.45	2009-11-22	9781930000000
130	Visual Explanations: Images and Quantities, Evidence and Narrative	156	4.29	1998-04-22	9780960000000
131	The Intelligent Web: Search, Smart Algorithms, and Big Data	295	3.70	2014-01-28	9780200000000
132	Principles of Transaction Processing	378	3.78	2009-06-01	9781560000000
133	The Mindi?1s I: Fantasies and Reflections on Self and Soul	512	4.14	1985-04-01	9780550000000
134	Managing Software Requirements: A Use Case Approach	502	3.50	2003-05-05	9780320000000
135	Software Testing	416	3.74	2005-07-01	9780670000000
136	Teach Yourself Uml In 24 Hours	\N	3.36	\N	9780670000000
137	MySQL Pocket Reference	96	3.84	2003-03-03	9780600000000
138	Fundamentals of Digital Logic with VHDL Design With CDROM	939	3.76	2004-07-15	9780070000000
139	Calendrical Calculations	479	4.23	2007-12-01	9780520000000
140	Liars and Outliers: Enabling the Trust that Society Needs to Thrive	348	3.77	2012-02-01	9781120000000
141	Beautiful Data: The Stories Behind Elegant Data Solutions (Theory In Practice, #31)	384	3.64	2009-07-28	9780600000000
142	Programming Distributed Computing Systems: A Foundational Approach	296	3.72	2013-05-31	9780260000000
143	Applied Predictive Modeling	600	4.45	2018-03-30	9781460000000
144	Living Clojure	300	4.09	2015-01-25	\N
145	Refactoring: Ruby Edition, Adobe Reader	480	4.10	2009-10-15	9780320000000
146	Embedded Android: Porting, Extending, and Customizing	\N	4.14	2011-10-22	9781450000000
147	Jenkins: The Definitive Guide	406	3.42	2011-07-27	9781450000000
148	The Lambda Calculus: Its Syntax and Semantics	654	4.21	1985-11-15	9780440000000
149	Generative Design: Visualize, Program, and Create with Processing	472	4.55	2012-08-22	9781620000000
150	API Design for C++	472	4.09	2011-02-18	9780120000000
151	Test-Driven iOS Development	256	3.56	2012-04-19	9780320000000
152	Designing with the Mind in Mind: Simple Guide to Understanding User Interface Design Rules	201	4.09	2010-05-20	9780080000000
153	The Imitation Game	197	3.63	2014-06-22	\N
154	The Systems Bible: The Beginner's Guide to Systems Large and Small: Being the Third Edition of Systemantics	314	4.04	2002-01-01	9780960000000
155	Great Principles of Computing	320	3.13	2015-01-23	9780260000000
156	Erlang and OTP in Action	432	4.27	2010-12-05	9781930000000
157	Pattern Oriented Software Architecture Volume 5: On Patterns and Pattern Languages	450	3.73	2007-06-01	9780470000000
158	Who Owns the Future?	367	3.77	2013-05-07	9781450000000
159	C# 6.0 and the .NET 4.6 Framework	1660	4.58	2015-11-11	\N
160	Mazes for Programmers: Code Your Own Twisty Little Passages	275	4.31	2015-09-25	9781680000000
161	Computer Science: Discovering God's Glory in Ones and Zeros	32	3.82	2015-03-08	\N
162	The Unicode Standard	1472	4.22	2006-11-01	9780320000000
163	Linux Phrasebook	382	4.12	2006-06-22	9780670000000
164	Cryptanalysis: A Study of Ciphers and Their Solution	256	3.79	1989-04-01	9780490000000
165	Swarm Intelligence: From Natural to Artificial Systems	307	3.96	1999-09-23	9780200000000
166	Programming in Go: Creating Applications for the 21st Century	475	3.75	2012-05-14	9780320000000
167	Head First JavaScript Programming	661	4.24	2014-03-22	9781450000000
168	Learning Web Design: A Beginner's Guide to Html, Css, Javascript, and Web Graphics	624	4.17	2012-08-24	9781450000000
169	Two Scoops of Django: Best Practices for Django 1.8	505	4.53	2015-04-29	\N
170	Theoretical Neuroscience: Computational and Mathematical Modeling of Neural Systems	480	4.26	2005-08-12	9780260000000
171	Geometric Algebra for Computer Science: An Object-Oriented Approach to Geometry	626	3.97	2007-04-01	9780120000000
172	Elasticsearch: The Definitive Guide: A Distributed Real-Time Search and Analytics Engine	724	4.23	2015-02-14	9781450000000
173	Bayesian Data Analysis	690	4.20	2003-07-29	9781580000000
174	The Art of Software Security Assessment: Identifying and Preventing Software Vulnerabilities	1174	4.45	2006-11-01	9780320000000
175	Principles of Distributed Database Systems	666	3.94	1999-01-19	9780140000000
176	Algorithms And Data Structures: The Basic Toolbox	300	4.00	2010-11-10	9783640000000
177	The Idea Factory: Bell Labs and the Great Age of American Innovation	432	4.15	2012-03-15	9781590000000
178	Bulletproof SSL and TLS: The Complete Guide to Deploying Secure Servers and Web Applications	425	4.59	2014-07-31	9781910000000
179	Pro ASP.NET MVC 5	832	4.13	2013-12-19	\N
180	PHP and MySQL for Dynamic Web Sites: Visual QuickPro Guide	692	3.83	2005-06-21	9780320000000
181	Java 8 Lambdas: Pragmatic Functional Programming	182	3.99	2014-04-22	9781450000000
182	Learn Ruby the Hard Way	173	3.67	2011-12-11	\N
183	Cybersecurity and Cyberwar: What Everyone Needs to Know(r)	306	3.83	2014-01-03	9780200000000
184	3D Math Primer for Graphics and Game Development	429	4.16	2002-06-21	9781560000000
185	HTML5 for Web Designers	87	4.02	2010-05-04	9780980000000
186	The Practice of Network Security Monitoring: Understanding Incident Detection and Response	376	4.03	2013-08-02	9781590000000
187	Hacker, Hoaxer, Whistleblower, Spy: The Many Faces of Anonymous	453	3.84	2014-11-04	9781780000000
188	Computer Vision: Models, Learning, and Inference	600	4.38	2012-06-18	9781110000000
189	Introduction to Graph Theory	224	4.09	1994-02-09	9780490000000
190	Performance Modeling and Design of Computer Systems: Queueing Theory in Action	576	4.70	2013-02-01	9781110000000
191	Comptia A+ Certification All-In-One Exam Guide: Exams 220-801 & 220-802	1200	4.16	2012-08-22	9780070000000
192	Thinking Functionally with Haskell	350	4.14	2014-10-09	9781110000000
193	Data Science at the Command Line: Facing the Future with Time-Tested Tools	212	3.87	2014-10-12	9781490000000
194	Linked Data	336	3.66	2013-03-22	9781620000000
195	The Black Box Society: The Secret Algorithms That Control Money and Information	320	3.63	2015-01-05	9780670000000
196	Applying Domain-Driven Design and Patterns : With Examples in C# and .NET	528	3.61	2006-05-01	9780320000000
197	Hatching Twitter: A True Story of Money, Power, Friendship, and Betrayal	299	4.04	2013-11-05	9781590000000
198	Algorithms Illuminated: Part 1: The Basics	\N	4.49	2017-09-26	\N
199	IBM PC Assembly Language and Programming	545	4.02	2000-08-22	9780130000000
200	Assembly Language for Intel-Based Computers	676	4.07	1998-09-08	9780140000000
201	Functional Programming in JavaScript	272	4.17	2016-06-22	\N
205	Brotopia: Breaking Up the Boys' Club of Silicon Valley	317	4.03	2018-02-06	\N
206	High Performance MySQL: Optimization, Backups, and Replication	826	4.39	2012-03-05	\N
223	Reactive Microservices Architecture	54	3.66	2016-03-22	\N
224	Essential Algorithms: A Practical Approach to Computer Algorithms	301	3.90	2013-08-12	9781120000000
225	The Unix Philosophy	176	4.05	1994-12-28	9781560000000
239	Programming Rust: Fast, Safe Systems Development	622	4.61	2017-12-21	9781490000000
240	Reactive Microsystems	84	4.48	2017-08-07	\N
241	Async JavaScript	104	4.02	2012-03-21	\N
242	A Common-Sense Guide to Data Structures and Algorithms: Level Up Your Core Programming Skills	\N	4.16	2017-10-25	9781680000000
243	Bad Choices	160	3.28	2017-04-04	9780740000000
244	Life in Code: A Personal History of Technology	320	3.96	2017-08-08	9780370000000
245	The Everything Store: Jeff Bezos and the Age of Amazon	384	4.12	2013-10-15	9780320000000
246	Computer Science: A Very Short Introduction	144	3.78	2016-06-01	9780200000000
247	Make Your Own Neural Network: An In-depth Visual Introduction For Beginners	316	4.21	2017-08-29	\N
248	Practical Statistics for Data Scientists: 50 Essential Concepts	318	4.05	2017-05-28	9781490000000
249	What Is Life? with Mind and Matter and Autobiographical Sketches	184	4.15	1992-01-31	9780520000000
250	Python Testing with Pytest: Simple, Rapid, Effective, and Scalable	\N	4.16	2017-10-25	9781680000000
251	The Age of Cryptocurrency: How Bitcoin and Digital Money Are Challenging the Global Economic Order	368	3.89	2015-01-27	9781250000000
252	Introducing Ethereum and Solidity: Foundations of Cryptocurrency and Blockchain Programming for Beginners	208	3.37	2017-03-18	9781480000000
253	The Cambridge Handbook of Artificial Intelligence	368	4.10	2014-07-31	9780520000000
254	Understanding the Digital World: What You Need to Know about Computers, the Internet, Privacy, and Security	256	4.28	2017-01-24	9780690000000
255	The Non-Designer's Design Book	191	4.05	2003-08-28	9780320000000
256	The CS Detective: An Algorithmic Tale of Crime, Conspiracy, and Computation	246	3.98	2016-08-16	9781590000000
257	High Performance Spark: Best Practices for Scaling and Optimizing Apache Spark	358	3.89	2017-06-16	9781490000000
258	Multiagent Systems: Algorithmic, Game-Theoretic, and Logical Foundations	504	3.68	2008-12-01	9780520000000
259	Exploring ES6	630	4.42	2015-06-13	\N
260	Web Scalability for Startup Engineers	416	4.58	2015-06-23	9780070000000
261	Hacking For Dummies	388	3.69	2006-11-01	9780470000000
262	The Nature of Software Development	\N	4.13	\N	\N
263	Computational Science and Engineering	716	4.00	2007-11-01	9780960000000
264	PHP Web Services: APIs for the Modern Web	118	3.64	2013-05-03	9781450000000
265	The Debian Administrator's Handbook	498	4.09	2012-04-22	\N
266	Lean Enterprise: How High Performance Organizations Innovate at Scale	352	4.25	2014-12-04	9781450000000
267	C++ For Dummies	432	3.59	2004-05-07	\N
268	Agile Project Management with Scrum	188	3.70	2004-02-18	9780740000000
269	Fundamentals of Machine Learning for Predictive Data Analytics: Algorithms, Worked Examples, and Case Studies	624	4.48	2015-07-24	9780260000000
270	Information: The New Language of Science	\N	3.91	2004-04-30	9780670000000
271	Machine Learning Yearning	\N	4.30	\N	\N
272	Game Physics Engine Development With CDROM	456	4.22	2007-03-07	9780120000000
273	Software Requirements 3	672	4.29	2013-08-12	9780740000000
274	The Developer's Code: What Real Programmers Do	142	3.42	2012-02-22	\N
275	Test Driven Development for Embedded C	352	4.20	2011-05-02	9781930000000
276	Coding Interview Questions	520	4.09	2012-05-02	9781480000000
277	Internetworking with TCP/IP Vol.1: Principles, Protocols, and Architecture	750	4.12	2000-01-18	9780130000000
278	Absolute C++	943	3.84	2007-03-01	9780320000000
279	Python Algorithms: Mastering Basic Algorithms in the Python Language	316	4.01	2010-11-24	9781430000000
280	Genetic Programming: On the Programming of Computers by Means of Natural Selection	836	4.28	1992-12-11	9780260000000
281	Ada, the Enchantress of Numbers: A Selection from the Letters of Lord Byron's Daughter and Her Description of the First Computer	439	3.34	1992-01-08	9780910000000
282	The Last Lecture	217	4.26	2008-04-11	\N
283	Principles of Program Analysis	452	3.87	2004-12-10	9783540000000
284	Term Rewriting and All That	316	4.11	2006-07-31	9780520000000
285	Java Examples in a Nutshell: A Companion Volume to Java in a Nutshell	397	3.47	1997-09-08	9781570000000
286	Database in Depth: Relational Theory for Practitioners	232	3.96	2005-05-15	9780600000000
287	Communication and Concurrency	300	4.73	1995-12-01	9780130000000
288	ERLANG Programming	496	4.09	2009-06-26	9780600000000
289	Data Compression Book	576	3.93	1995-12-14	9781560000000
427	The Latex Companion	1120	4.03	2004-05-02	9780200000000
290	Blown to Bits: Your Life, Liberty, and Happiness After the Digital Explosion	366	3.63	2008-06-01	9780140000000
291	Programming Languages: Design and Implementation	672	3.91	2000-09-07	9780130000000
292	The Art of Assembly Language	928	3.70	2003-09-08	9781890000000
293	Introduction to Parallel Computing	656	3.39	2003-01-26	9780200000000
294	Introduction to Computational Genomics	182	4.00	2007-02-01	9780520000000
295	Problem Solving with C++: The Object of Programming	800	3.72	1996-01-01	9780810000000
296	Ship It,	200	3.75	2005-06-08	9780970000000
297	Cloud Application Architectures: Building Applications and Infrastructure in the Cloud	208	3.07	2009-04-10	9780600000000
298	Common LISP: The Language	1029	4.26	1984-06-29	9781560000000
299	C++: The Complete Reference	1056	4.04	2002-12-10	9780070000000
300	Revolution in The Valley: The Insanely Great Story of How the Mac Was Made	291	4.17	2004-12-16	9780600000000
301	Introduction to Computer Theory	648	3.89	1996-10-25	9780470000000
302	Network Security Essentials: Applications and Standards	413	3.81	2006-07-01	9780130000000
303	The Formal Semantics of Programming Languages: An Introduction	384	3.68	1993-02-05	9780260000000
304	Java Performance	720	4.11	\N	\N
305	C++ from the Ground Up	624	4.02	2003-04-09	9780070000000
306	Lionsi?1 Commentary on UNIX 6th Edition with Source Code	254	4.38	1996-01-01	9781570000000
307	Beyond Fear: Thinking Sensibly about Security in an Uncertain World	296	4.00	2006-05-04	9780390000000
308	Communication Networks: Fundamental Concepts and Key Architectures	928	4.17	2003-07-16	639786000000
309	Computability: An Introduction to Recursive Function Theory	264	3.76	1980-06-19	9780520000000
310	Logik fA1r Informatiker	200	3.23	2000-01-01	9783830000000
311	Fluid Concepts and Creative Analogies	528	3.98	1996-03-22	9780470000000
312	Core Java 2, Volume I--Fundamentals (Core Series)	784	3.83	2004-08-27	9780130000000
313	VI Editor Pocket Reference (Pocket Reference	80	4.02	1999-01-25	9781570000000
314	Practical UNIX & Internet Security	1004	3.86	1996-04-08	9781570000000
315	An Introduction to Bioinformatics Algorithms	456	3.78	2004-08-06	9780260000000
316	Eniac: The Triumphs and Tragedies of the World's First Computer	262	3.78	2001-02-01	9780430000000
317	No Tech Hacking: A Guide to Social Engineering, Dumpster Diving, and Shoulder Surfing	285	4.00	2008-02-01	9781600000000
318	The Google Story: Inside the Hottest Business, Media, and Technology Success of Our Time	336	3.84	2008-09-23	9780550000000
319	Quality Software Management: Systems Thinking	336	4.26	1992-01-01	9780930000000
320	The Standard C Library	512	4.12	1991-07-11	9780130000000
321	Beginning Linux Programming	848	3.78	2004-01-02	9780760000000
322	Ruminations on C++: A Decade of Programming Insight and Experience	400	3.91	1996-08-17	9780200000000
323	The Hundred-Page Machine Learning Book	\N	4.64	\N	\N
324	Starting Out with C++: From Control Structures Through Objects	1248	3.90	2011-03-07	9780130000000
325	Building Machine Learning Systems with Python	350	3.86	2013-09-30	9781780000000
326	Core J2EE Patterns: Best Practices and Design Strategies	528	3.41	2003-06-20	9780130000000
327	Java Generics and Collections: Speed Up the Java Development Process	286	3.94	2006-10-24	9780600000000
328	UNIX Network Programming, Volume 2: Interprocess Communications	592	4.35	1998-09-04	9780130000000
329	Pattern-Oriented Software Architecture Volume 2: Patterns for Concurrent and Networked Objects	666	3.65	2000-10-03	9780470000000
330	Computer: A History of the Information Machine	376	4.11	2013-07-30	9780810000000
331	A Programmer's Introduction to Mathematics	378	3.83	2018-11-27	9781730000000
332	Programming Languages: Principles and Practice	720	3.12	2002-07-16	9780530000000
333	Machine Learning in Action	384	3.74	2012-04-16	9781620000000
334	What is DevOps?	18	3.53	2012-06-11	\N
335	Let Us C	746	4.12	2004-03-22	9788180000000
336	Working with UNIX Processes	148	4.06	2012-01-01	\N
337	Computability and Unsolvability	288	3.87	1985-12-01	9780490000000
338	File Structures: An Object-Oriented Approach with C++	724	3.89	1997-12-16	9780200000000
339	Mathematical Logic for Computer Science	354	3.77	2011-11-22	9781850000000
340	Operating System Concepts Essentials	725	3.76	2010-11-23	9780470000000
341	Python Programming for the Absolute Beginner	472	3.89	2005-11-08	9781600000000
342	Algorithms of the Intelligent Web	368	3.61	2009-07-05	9781930000000
343	Making Software: What Really Works, and Why We Believe It	624	3.48	2010-10-27	9780600000000
344	Operating System Concepts with Java	1020	3.74	2009-11-01	9780470000000
345	An Introduction to Kolmogorov Complexity and Its Applications	637	3.96	1997-02-27	9780390000000
346	Responsive Web Design	150	4.16	2011-06-07	\N
347	The Hacker Ethic: A Radical Approach to the Philosophy of Business	256	3.71	2002-02-12	9780380000000
348	Invent Your Own Computer Games with Python	438	4.05	2010-05-01	9780980000000
349	Machine Learning: An Algorithmic Perspective	390	3.64	2009-04-01	9781420000000
350	DSLs in Action	376	3.49	2011-01-04	9781940000000
351	Real Digital Forensics: Computer Security and Incident Response	688	4.13	2005-09-23	\N
352	Game Coding Complete	928	4.01	2003-06-15	9781930000000
353	Principles of Programming Languages: Design, Evaluation, and Implementation	528	3.70	1999-03-25	9780200000000
354	Discrete and Combinatorial Mathematics	800	3.62	2003-07-27	9780200000000
355	Object-Oriented Software Engineering: Using UML, Patterns and Java	762	3.68	2003-09-25	9780130000000
356	The Art of Doing Science and Engineering: Learning to Learn	376	4.28	1997-10-28	9789060000000
357	Numerical Recipes: The Art of Scientific Computing	1235	4.23	2007-10-01	9780520000000
358	Worm: The First Digital World War	233	3.55	2011-09-27	9780800000000
359	CSS Mastery: Advanced Web Standards Solutions	255	4.11	2006-02-01	9781590000000
360	Unlocking the Clubhouse: Women in Computing	184	4.18	2003-02-28	9780260000000
361	D Is for Digital: What a Well-Informed Person Should Know about Computers and Communications	238	4.22	2011-09-23	9781460000000
362	A Practical Guide to Linux Commands, Editors, and Shell Programming	1008	4.00	2005-07-01	9780130000000
363	Introduction to Evolutionary Computing	300	4.03	2007-08-06	9783540000000
364	Wikinomics: How Mass Collaboration Changes Everything	324	3.72	2006-12-12	9781590000000
365	Software Craftsmanship: The New Imperative	182	3.92	2001-09-02	9780200000000
366	Head First HTML with CSS & XHTML	702	4.14	2005-12-01	9780600000000
367	Webmaster in a Nutshell	537	3.65	1999-06-11	9781570000000
368	A Gift of Fire: Social, Legal, and Ethical Issues for Computers and the Internet	464	3.33	2002-06-05	9780130000000
369	Perl Pocket Reference	96	4.22	2002-07-29	9780600000000
370	More Exceptional C++: 40 New Engineering Puzzles, Programming Problems, and Solutions	304	4.20	2001-12-17	9780200000000
371	Real-Time Collision Detection (The Morgan Kaufmann Series in Interactive 3d Technology)	632	4.45	2004-12-22	9781560000000
372	Clever Algorithms: Nature-Inspired Programming Recipes	436	3.73	2011-01-22	\N
373	Learning OpenCV: Computer Vision with the OpenCV Library	580	4.01	2008-10-01	9780600000000
374	Grace Hopper and the Invention of the Information Age (Lemelson Center Studies in Invention and Innovation series)	408	3.83	2009-07-10	9780260000000
375	Deep Thinking: Where Machine Intelligence Ends and Human Creativity Begins	\N	3.94	2017-05-02	9781480000000
376	Deep Learning: A Practitioner's Approach	200	3.71	2015-08-15	9781490000000
377	Professor Frisby's Mostly Adequate Guide to Functional Programming	115	4.36	\N	\N
378	Turing's Vision: The Birth of Computer Science	208	4.29	2016-05-13	9780260000000
379	Mathematical Elements for Computer Graphics	611	4.02	1989-08-01	9780070000000
380	Chaos: Making a New Science	352	3.99	1988-12-01	9780140000000
381	Operating Systems: Internals and Design Principles	818	3.65	2005-02-14	9780130000000
382	Working Effectively with Unit Tests	204	4.04	2014-06-29	\N
383	Best Practices of Spell Design	140	3.84	2013-01-21	9781480000000
384	Mathematical Structures for Computer Science	784	3.98	2006-07-07	9780720000000
385	BDD in Action: Behavior-driven development for the whole software lifecycle	384	4.09	2014-10-12	9781620000000
1171	Understanding Computation: From Simple Machines to Impossible Programs	332	4.23	2013-05-10	9781450000000
386	The Business Blockchain: Promise, Practice, and Application of the Next Internet Technology	208	3.49	2016-04-26	9781120000000
387	Basic Proof Theory	355	3.83	1996-09-13	9780520000000
388	Patterns Principles and Practices of Domain Driven Design	736	4.29	2015-03-22	\N
389	The Princeton Companion to Mathematics	1034	4.39	2008-09-28	9780690000000
390	Docker: Up & Running: Shipping Reliable Containers in Production	230	3.76	2015-06-09	9781490000000
391	Introduction to 64 Bit Intel Assembly Language Programming for Linux: Second Edition	310	3.86	2012-07-02	\N
392	Pragmatic Unit Testing in Java 8 with Junit	200	3.77	2015-03-19	9781940000000
393	Modern Processor Design: Fundamentals of Superscalar Processors	642	4.25	2013-08-12	9781480000000
394	Visualize This: The FlowingData Guide to Design, Visualization, and Statistics	358	3.88	2011-07-20	9780470000000
395	Data Structures Using C and C++	672	4.21	1995-12-29	9780130000000
396	How to Think About Algorithms	472	3.87	2008-05-19	\N
397	Operating Systems: Principles and Practice	674	4.10	2012-07-17	9780990000000
398	Complex Adaptive Systems: An Introduction to Computational Models of Social Life	263	3.95	2007-03-01	9780690000000
399	Exercises in Programming Style	304	4.39	2014-06-16	9781480000000
400	An Introduction to Parallel Programming	370	3.78	2011-01-21	9780120000000
401	SSH Mastery: OpenSSH, PuTTY, Tunnels and Keys	150	4.16	2012-01-18	\N
402	How to Break Software: A Practical Guide to Testing	208	3.66	2002-05-09	\N
403	Taming Text	322	3.81	2013-01-21	9781930000000
404	Write Great Code: Volume 2: Thinking Low-Level, Writing High-Level	640	4.05	2006-03-18	9781590000000
405	Core Java, Volume II--Advanced Features	1002	3.96	\N	9780130000000
406	Adrenaline Junkies and Template Zombies: Understanding Patterns of Project Behavior	238	3.95	2008-03-01	9780930000000
407	The Art of Memory Forensics: Detecting Malware and Threats in Windows, Linux, and Mac Memory	912	4.38	2014-07-28	9781120000000
408	Testing Computer Software	480	3.88	1999-04-26	9780470000000
409	Beginning Java EE 7	603	3.95	2013-06-26	\N
410	Web Operations: Keeping the Data on Time	315	4.11	2010-07-01	9781450000000
411	Object Design: Roles, Responsibilities, and Collaborations	416	3.70	2002-11-18	785342000000
412	Bash Cookbook: Solutions and Examples for Bash Users	630	3.90	2007-05-31	9780600000000
413	RabbitMQ in Action	312	3.94	2012-05-01	9781940000000
414	How the Mind Works	660	3.97	1999-01-17	9780390000000
415	Pro C# 5.0 and the .Net 4.5 Framework	1560	4.26	2012-08-27	9781430000000
417	Service Design Patterns: Fundamental Design Solutions for SOAP/WSDL and RESTful Web Services	321	3.71	2011-10-28	9780320000000
418	Linux Command Line and Shell Scripting Bible	809	4.12	2008-06-01	9780470000000
419	The Art of R Programming: A Tour of Statistical Software Design	400	4.08	2011-10-12	9781590000000
420	Computer Security: Principles and Practice	798	3.74	2008-07-01	9780140000000
421	C# 5.0 in a Nutshell: The Definitive Reference	1064	4.30	2012-06-26	9781450000000
422	An Introduction to Programming in Go	161	3.77	2012-09-03	\N
423	Principles of Model Checking	975	3.72	2008-05-01	9780260000000
424	Essential System Administration	788	3.84	1995-09-08	9781570000000
425	MapReduce Design Patterns: Building Effective Algorithms and Analytics for Hadoop and Other Systems	230	3.91	2012-12-22	9781450000000
426	Real World OCaml: Functional programming for the masses	510	4.23	2013-11-22	9781450000000
428	The Definitive Guide to Django: Web Development Done Right	447	3.86	2007-12-01	9781590000000
429	Succeeding with Agile: Software Development Using Scrum	475	4.00	2009-10-01	9780320000000
430	Type Theory And Functional Programming	372	4.20	1991-08-01	9780200000000
431	CSS: The Missing Manual	560	4.12	2009-09-01	9780600000000
432	Semantics of Programming Languages: Structures and Techniques	\N	3.44	1992-09-14	9780260000000
433	What Computers Still Can't Do: A Critique of Artificial Reason	408	4.12	1992-10-30	9780260000000
434	The Recursive Universe: Cosmic Complexity and the Limits of Scientific Knowledge	252	3.95	1985-10-01	9780810000000
435	ML for the Working Programmer	500	3.76	1996-06-28	9780520000000
436	Designing With Web Standards	456	4.09	2003-05-14	9780740000000
437	Languages and Machines: An Introduction to the Theory of Computer Science	654	3.56	2005-02-24	9780320000000
438	Object-Oriented Design Heuristics	379	4.18	1996-04-30	9780200000000
439	802.11 Wireless Networks: The Definitive Guide	672	3.64	2005-05-02	9780600000000
440	Object-Oriented JavaScript	337	4.16	2008-07-24	9781850000000
441	Programming in Objective-C 2.0	600	3.85	2008-11-01	9780320000000
442	Little Brother	382	3.93	2008-04-29	9780770000000
443	Physics for Game Developers	344	3.47	2001-11-23	9780600000000
444	Network Algorithmics: An Interdisciplinary Approach to Designing Fast Networked Devices	496	4.30	2004-12-01	9780120000000
445	Google's Pagerank and Beyond: The Science of Search Engine Rankings	224	3.70	2006-05-01	9780690000000
446	Approximation Algorithms	380	4.19	2002-12-05	9783540000000
447	Software Systems Architecture: Working with Stakeholders Using Viewpoints and Perspectives	576	4.07	2005-04-01	9780320000000
448	Operating System Principles	366	3.78	1973-01-01	9780140000000
449	Writing Efficient Programs	170	4.00	1982-01-01	9780140000000
450	HTTP: The Definitive Guide	656	4.14	2002-10-07	9781570000000
451	Rebel Code: Linux and the Open Source Revolution	344	3.90	2002-07-11	9780740000000
452	Computers & Typesetting, Volume A: The TeXBook	483	4.32	1986-01-11	9780200000000
453	SQL Pocket Guide	184	3.90	2006-04-27	9780600000000
454	Linux Device Drivers	615	4.08	2005-02-17	9780600000000
455	JavaScript Bible	1236	3.70	2004-03-22	9780760000000
456	Computer Algorithms: Introduction to Design and Analysis	600	3.53	1988-01-01	9780200000000
457	Object-Oriented Software Engineering	552	3.79	1992-07-01	785343000000
458	Pattern-Oriented Software Architecture Volume 1: A System of Patterns	476	3.85	1996-08-16	9780470000000
459	Large-Scale C++ Software Design	896	3.90	1996-07-20	9780200000000
460	Documenting Software Architectures: Views and Beyond	560	3.69	2002-10-06	9780200000000
461	Pattern Hatching: Design Patterns Applied	160	3.73	1998-07-02	9780200000000
462	Serious Cryptography: A Practical Introduction to Modern Encryption	312	4.25	2017-11-21	\N
463	Python Tricks	304	4.40	2017-10-25	9781780000000
464	Beyond Software Architecture: Creating and Sustaining Winning Solutions	352	3.72	2003-02-09	9780200000000
465	The Site Reliability Workbook: Practical Ways to Implement SRE	512	4.29	2018-08-04	9781490000000
466	Kubernetes: Up & Running	202	3.99	2016-01-31	9781490000000
467	Hit Refresh	273	3.77	2017-11-15	9780060000000
468	Fundamentals of Deep Learning: Designing Next-Generation Artificial Intelligence Algorithms	298	3.90	2015-07-22	9781490000000
469	Homo Deus: A Brief History of Tomorrow	450	4.29	2017-02-21	\N
470	From Counterculture to Cyberculture: Stewart Brand, the Whole Earth Network, and the Rise of Digital Utopianism	327	3.97	2006-09-23	9780230000000
471	Practical Reverse Engineering: x86, x64, ARM, Windows Kernel, Reversing Tools, and Obfuscation	355	3.88	2014-02-17	9781120000000
472	Storytelling with Data: A Data Visualization Guide for Business Professionals	288	4.37	2015-11-02	9781120000000
473	Overcomplicated: Technology at the Limits of Comprehension	240	3.38	2016-07-19	9781590000000
474	Node.Js the Right Way: Practical, Server-Side JavaScript That Scales	148	3.86	2013-12-05	9781940000000
475	Probably Approximately Correct: Nature's Algorithms for Learning and Prospering in a Complex World	208	3.62	2013-06-04	9780470000000
476	SmallTalk 80 Language: The Language and Its Implementation	714	4.68	1983-03-01	9780200000000
477	CSS: The Definitive Guide	518	3.99	2006-11-01	9780600000000
478	Universal Principles of Design: 100 Ways to Enhance Usability, Influence Perception, Increase Appeal, Make Better Design Decisions, and Teach Through Design	216	4.13	2003-10-01	9781590000000
479	Lean from the Trenches	176	4.20	2011-12-21	9781930000000
480	Genetic Programming: An Introduction On The Automatic Evolution Of Computer Programs And Its Applications	\N	3.82	\N	9781560000000
481	Graphics Programming Black Book Special Edition	1200	4.48	1997-09-01	9781580000000
482	Linux System Programming: Talking Directly to the Kernel and C Library	429	4.20	2013-06-05	9781450000000
483	How to Solve It by Computer	442	4.12	1982-07-01	9780130000000
484	The Grammar of Graphics	691	4.20	2005-06-01	9780390000000
485	Effective C#: 50 Specific Ways to Improve Your C#	307	4.01	2004-12-13	9780320000000
486	Slack: Getting Past Burnout, Busywork, and the Myth of Total Efficiency	256	4.01	2002-04-09	9780770000000
487	Software Requirements: Practical Techniques for Gathering and Managing Requirements Throughout the Product Development Cycle	516	3.97	2003-03-08	9780740000000
488	Collective Intelligence in Action	425	3.74	2008-11-04	9781930000000
489	The Hacker Crackdown: Law and Disorder on the Electronic Frontier	336	3.74	1993-11-01	9780550000000
490	The Art of SQL	349	3.92	2006-03-01	9780600000000
491	Algorithms in C, Part 5: Graph Algorithms	512	3.96	2001-08-26	9780200000000
492	Computability Theory	420	4.62	2003-11-17	9781580000000
493	Tmux: Productive Mouse-Free Development	88	3.92	2012-02-29	9781930000000
564	Machine Learning with R	396	4.22	2014-06-13	9781310000000
494	Linked: How Everything Is Connected to Everything Else and What It Means for Business, Science, and Everyday Life	304	3.93	2003-04-29	9780450000000
495	The AWK Programming Language	224	4.25	1988-01-11	9780200000000
496	Inside the C++ Object Model	304	4.20	1996-05-13	9780200000000
497	Agile Testing: A Practical Guide for Testers and Agile Teams	533	3.83	2009-01-09	9780320000000
498	Clojure Programming	630	4.18	2012-04-19	9781450000000
499	Programming in Objective C	556	3.96	2003-12-08	9780670000000
500	Lambda-Calculus, Combinators and Functional Programming	192	3.00	2009-02-27	9780520000000
501	Causality: Models, Reasoning, and Inference	400	4.18	2000-03-13	9780520000000
502	Why Programs Fail: A Guide to Systematic Debugging	400	3.91	2009-06-01	9780120000000
503	The Best Software Writing I: Selected and Introduced by Joel Spolsky	305	3.84	2005-10-21	9781590000000
504	The Architecture of Open Source Applications, Volume II	390	4.05	2012-05-08	9781110000000
505	Head First HTML5 Programming	610	3.99	2011-10-18	9781450000000
506	Code Craft: The Practice of Writing Excellent Code	610	3.96	2006-12-21	9781590000000
507	High Performance MySQL: Optimization, Backups, Replication & Load Balancing	304	4.24	2004-04-18	9780600000000
508	Web Form Design: Filling in the Blanks	226	4.04	2008-12-01	9781930000000
509	Antipatterns: Refactoring Software, Architectures, and Projects in Crisis	336	3.79	1998-04-03	9780470000000
510	Cassandra: The Definitive Guide	330	3.59	2010-11-29	9781450000000
511	Algorithms in C++	672	3.94	1992-04-30	785343000000
512	Agile Retrospectives: Making Good Teams Great	170	3.91	2006-08-02	9780980000000
513	The Art of Scalability: Scalable Web Architecture, Processes, and Organizations for the Modern Enterprise	559	3.96	2009-12-01	9780140000000
514	Core Python Programming	1100	3.86	2006-09-28	9780130000000
515	Algorithms in C, Parts 1-4: Fundamentals, Data Structures, Sorting, Searching	720	4.14	1997-09-27	785342000000
516	The Art of Computer Programming, Volume 4, Fascicles 0-4	944	5.00	2009-04-01	9780320000000
517	Concepts in Programming Languages	540	3.45	2010-07-23	9780520000000
518	Data and Computer Communications	878	3.87	2006-08-01	9780130000000
519	The Society of Mind	336	4.01	1988-03-15	9780670000000
520	The Emotion Machine: Commonsense Thinking, Artificial Intelligence, and the Future of the Human Mind	400	3.76	2006-11-07	9780740000000
521	Data Structures and Algorithms in C++	528	3.70	2000-06-30	9780530000000
522	Artificial Intelligence for Games (The Morgan Kaufmann Series in Interactive 3D Technology)	896	4.17	2006-06-21	9780120000000
523	Programming in Python 3: A Complete Introduction to the Python Language	552	3.69	2008-12-26	9780140000000
524	The Internet of Money	150	4.13	2016-08-29	\N
525	The Art of Electronics	1152	4.33	1989-07-28	9780520000000
526	A Pattern Language: Towns, Buildings, Construction	1216	4.39	1977-08-25	9780200000000
527	Distributed Systems	582	4.09	2017-02-01	9781540000000
528	The Hardware Hacker: Adventures in Making and Breaking Hardware	396	4.29	2017-03-09	9781590000000
529	Kotlin in Action	360	4.50	2016-05-23	9781620000000
530	Web Scraping with Python: Collecting Data from the Modern Web	256	4.14	2015-06-15	\N
531	What the Dormouse Said: How the Sixties Counterculture Shaped the Personal Computer Industry	310	3.81	2006-02-28	9780140000000
532	Chaos Monkeys: Obscene Fortune and Random Failure in Silicon Valley	528	3.72	2016-06-28	9780060000000
533	Hello Ruby: Adventures in Coding	112	3.90	2015-10-06	9781250000000
534	Zero Bugs and Program Faster	182	3.71	2016-01-01	9781000000000
535	Steal This Computer Book 4.0 Acâ‚¬â€o What They WonAcâ‚¬2t Tell You About the Internet 4e	376	3.66	2006-05-11	9781590000000
536	Software Architecture Patterns	47	3.69	2015-03-23	\N
537	Elixir in Action, Second Edition	384	4.50	2019-01-23	\N
538	Clojure for the Brave and True	352	4.27	\N	\N
539	The Robert C. Martin Clean Code Collection (Collection)	699	4.51	2011-11-10	9780130000000
540	The Inevitable: Understanding the 12 Technological Forces That Will Shape Our Future	336	3.96	2016-06-07	\N
541	Database Systems: A Practical Approach to Design, Implementation and Management	1424	3.67	2004-05-24	9780320000000
542	Mastering Emacs	280	4.16	2015-05-23	\N
543	Ada Byron Lovelace and the Thinking Machine	40	4.19	2015-10-13	9781940000000
544	Structured Programming	234	4.23	1972-03-23	9780120000000
545	Amazon Web Services in Action	424	3.81	2015-10-17	9781620000000
546	Free Software, Free Society: Selected Essays	224	4.13	2002-10-01	9781880000000
547	Reactive Messaging Patterns with the Actor Model: Applications and Integration in Scala and Akka	480	3.56	2015-08-17	9780130000000
548	Management 3.0: Leading Agile Developers, Developing Agile Leaders	451	4.14	2010-12-28	9780320000000
549	Modern C++ Programming with Test-Driven Development: Code Better, Sleep Better	380	4.43	2013-10-20	9781940000000
550	Java: A Beginner's Guide (Beginner's Guide)	\N	3.96	2005-04-01	9780070000000
551	Program or Be Programmed: Ten Commands for a Digital Age	152	3.69	2010-11-01	\N
552	Data Structure and Algorithmic Thinking with Python	468	4.10	2015-01-29	9788190000000
553	Theory of Recursive Functions and Effective Computability	506	4.00	1987-04-22	9780260000000
554	Dataclysm: Who We Are (When We Think No One's Looking)	304	3.74	2014-09-09	9780390000000
555	Linux Bible	864	4.30	2012-09-11	9781120000000
556	Java:  The Complete Reference	1000	4.15	2011-02-07	9780070000000
558	Black Hat Python: Python Programming for Hackers and Pentesters	171	4.07	2014-12-14	9781590000000
559	Build Your Own Lisp	\N	4.22	2014-03-23	\N
560	Ruby Under a Microscope	272	4.37	2012-03-23	\N
561	A Bug Hunter's Diary: A Guided Tour Through the Wilds of Software Security	208	3.92	2011-11-11	9781590000000
562	Advanced Concepts in Operating Systems	448	3.96	1994-01-01	9780070000000
563	A History of Modern Computing	459	3.96	2003-04-08	9780260000000
565	The Hacker Playbook: Practical Guide To Penetration Testing	294	3.99	2014-03-20	\N
566	Intuition Pumps And Other Tools for Thinking	496	3.79	2014-05-05	9780390000000
567	Flash Boys: A Wall Street Revolt	320	4.14	2015-03-23	9780390000000
568	The Search: How Google and Its Rivals Rewrote the Rules of Business and Transformed Our Culture	320	3.83	2005-09-08	9781590000000
569	Introduction to Reliable and Secure Distributed Programming	367	4.41	2011-02-12	9783640000000
570	Reinventing Discovery: The New Era of Networked Science	264	3.92	2011-10-23	9780690000000
571	Hacking the Xbox: An Introduction to Reverse Engineering	288	4.07	2003-07-01	9781590000000
572	R Graphics Cookbook: Practical Recipes for Visualizing Data	416	4.24	2012-12-06	9781450000000
573	21st Century C: C Tips from the New School	296	3.81	2012-11-05	9781450000000
574	MongoDB: The Definitive Guide	216	3.85	2010-09-24	9781450000000
595	Foundations of Computer Science	624	3.95	2007-12-01	9781840000000
596	Programming from the Ground Up	332	4.12	2004-07-01	9780980000000
597	Confident Ruby	296	4.40	2012-06-05	\N
598	Agile Software Development with Scrum	158	3.82	2001-10-21	9780130000000
628	The Quick Python Book	367	3.82	2010-01-22	9781940000000
629	Kanban: Successful Evolutionary Change for Your Technology Business	262	3.97	2010-04-07	9780980000000
630	Team Geek: A Software Developer's Guide to Working Well with Others	167	3.97	2012-07-21	9781450000000
631	Data Structures and Algorithm Analysis in Java	576	3.63	2006-03-03	9780320000000
632	Fundamentals of Computer Graphics	392	3.67	2002-06-15	9781570000000
633	Rework	279	3.94	2010-03-09	9780310000000
634	Conceptual Mathematics: A First Introduction To Categories	\N	4.32	1997-11-28	9780520000000
635	Object-Oriented Programming in C++	1012	4.11	2001-12-29	9780670000000
636	Design for Hackers: Reverse Engineering Beauty	352	3.74	2011-08-29	9781120000000
637	The Sciences of the Artificial	248	4.23	1996-09-26	9780260000000
638	Certified Programming with Dependent Types: A Pragmatic Introduction to the Coq Proof Assistant	424	4.09	2013-12-06	9780260000000
639	Test Driven: Practical TDD and Acceptance TDD for Java Developers	513	3.83	2007-10-19	9781930000000
640	Python Pocket Reference	148	4.00	2005-03-06	9780600000000
641	SCJP Sun Certified Programmer for Java 6 Study Guide	851	4.28	2008-06-24	9780070000000
642	Computer Organization	832	3.67	2001-08-02	9780070000000
643	Refactoring Databases: Evolutionary Database Design	384	3.70	2006-03-03	9780320000000
644	jQuery: Novice to Ninja	407	3.91	2010-03-07	9780980000000
645	Thinking in C++, Volume One: Introduction to Standard C++	840	4.12	2000-03-25	76092006565
646	Learning Java	954	3.60	2005-05-30	9780600000000
647	Managing Humans: Biting and Humorous Tales of a Software Engineering Manager	209	3.97	2007-06-01	9781590000000
648	Programming the Semantic Web	302	3.69	2009-07-21	9780600000000
649	CSS3 For Web Designers	125	4.06	2010-11-16	\N
650	Data Communications and Networking (McGraw-Hill Forouzan Networking)	1168	3.90	2006-02-09	9780070000000
651	SQL and Relational Theory: How to Write Accurate SQL Code	428	3.75	2009-01-30	9780600000000
652	The Art of Computer Programming, Volume 4, Fascicle 4: Generating All Trees--History of Combinatorial Generation	120	4.50	2006-02-01	9780320000000
653	How Would You Move Mount Fuji? Microsoft's Cult of the Puzzle--How the World's Smartest Companies Select the Most Creative Thinkers	288	3.57	2004-04-02	9780320000000
654	The Road Ahead	286	3.69	1995-11-21	9780670000000
655	Being Geek: The Software Developer's Career Handbook	318	3.70	2010-08-10	9780600000000
656	The Art of Software Testing	256	3.69	2004-06-21	9780470000000
657	The RSpec Book	426	3.87	2010-12-22	9781930000000
658	The Implementation (TCP/IP Illustrated, Volume 2)	1174	4.21	1995-02-10	9780200000000
659	Communicating Sequential Processes (Prentice Hall International Series in Computing Science)	256	4.33	1985-04-01	9780130000000
660	Interactive Theorem Proving and Program Development: Coq Art: The Calculus of Inductive Constructions	472	3.86	2004-05-14	9783540000000
661	Garbage Collection: Algorithms for Automatic Dynamic Memory Management	404	4.13	1996-08-16	9780470000000
662	Database Systems: Design, Implementation, and Management	696	3.56	2006-01-27	9781420000000
663	Learning GNU Emacs	536	3.63	2004-12-20	9780600000000
664	Essential System Administration: Tools and Techniques for Linux and Unix Administration	1176	3.96	2002-09-02	9780600000000
665	TCP/IP Network Administration	748	3.86	2002-04-11	9780600000000
666	PHP & MySQL For Dummies	436	3.54	2006-12-01	9780470000000
667	The Art of Computer Programming, Volume 1, Fascicle 1: MMIX -- A RISC Computer for the New Millennium	134	4.19	2005-02-24	9780200000000
668	Exceptional C++: 47 Engineering Puzzles, Programming Problems, and Solutions	208	4.18	1999-11-28	9780200000000
669	The Little Typer	424	4.35	2018-09-18	9780260000000
670	Mathematics for Computer Science	1048	3.91	2010-09-08	\N
671	Cryptography: Theory and Practice (Discrete Mathematics and Its Applications)	593	3.71	2005-11-01	9781580000000
672	Introduction to Artificial Intelligence	454	3.75	1985-06-01	9780490000000
673	Software Project Survival Guide	306	3.82	1997-10-22	9781570000000
674	Speaking JavaScript	460	4.37	2014-03-24	9781450000000
675	Prediction Machines: The Simple Economics of Artificial Intelligence	272	4.00	2018-04-17	\N
676	Introduction to Linear Algebra	568	4.20	2003-01-01	9780960000000
677	Girls Who Code: Learn to Code and Change the World	176	4.10	2017-08-24	9780750000000
678	Technically Wrong: Sexist Apps, Biased Algorithms, and Other Threats of Toxic Tech	240	4.16	2018-10-16	9780390000000
679	Think Java: How to Think Like a Computer Scientist	248	3.66	2012-03-23	\N
680	Quantum Computer Science	220	3.59	2007-08-01	9780520000000
681	Designing Distributed Systems: Patterns and Paradigms for Scalable, Reliable Services	149	3.53	2018-03-05	9781490000000
682	UNIX in a Nutshell: A Desktop Quick Reference - Covers GNU/Linux, Mac OS X, and Solaris	908	3.90	2005-11-02	9780600000000
683	Envisioning Information	126	4.22	1992-12-23	9780960000000
684	Programming Collective Intelligence: Building Smart Web 2.0 Applications	362	4.07	2007-08-23	9780600000000
685	Bitcoin and Cryptocurrency Technologies: A Comprehensive Introduction	336	4.41	2016-07-19	9780690000000
686	Intermediate Perl	256	3.97	2006-03-18	9780600000000
687	Head First Python	494	3.77	2010-12-07	9781450000000
688	Type-Driven Development with Idris	453	4.51	2017-04-07	9781620000000
689	Functional and Reactive Domain Modeling	320	4.19	2016-08-28	9781620000000
690	Future Crimes: Everything Is Connected, Everyone Is Vulnerable, and What We Can Do About It	393	3.94	2015-02-24	9780390000000
691	Blockchain: Blueprint for a New Economy	152	3.31	2015-01-24	\N
692	Metaprogramming Ruby 2: Program Like the Ruby Pros	280	4.47	2014-08-18	9781940000000
693	Computing: A Concise History	199	3.63	2012-06-15	9780260000000
694	If Hemingway Wrote JavaScript	192	4.17	2014-10-23	9781590000000
695	Just Enough Software Architecture: A Risk-Driven Approach	360	3.53	2010-09-01	9780980000000
696	Software Architecture for Developers: Volume 1 - Technical leadership and the balance with agility	133	3.84	2016-11-18	\N
697	High Performance Python: Practical Performant Programming for Humans	370	4.17	2014-08-25	9781450000000
698	Introduction to Computing Systems: From Bits & Gates to C & Beyond	656	3.77	2003-08-05	9780070000000
699	Learning Agile: Understanding Scrum, XP, Lean, and Kanban	400	4.12	2014-06-22	9781450000000
700	Computability, Complexity, and Languages: Fundamentals of Theoretical Computer Science (Computer Science and Scientific Computing)	609	3.96	1994-02-17	9780120000000
701	Reactive Design Patterns	325	3.54	2014-03-28	9781620000000
702	Counter Hack Reloaded: A Step-By-Step Guide to Computer Attacks and Effective Defenses	748	3.96	2005-12-23	9780130000000
703	Android Programming: The Big Nerd Ranch Guide	602	4.31	2013-04-07	9780320000000
704	Data Structures and Algorithms in Python	768	4.08	2013-03-18	9781120000000
705	The Basics of Hacking and Penetration Testing: Ethical Hacking and Penetration Testing Made Easy	159	3.91	2011-08-04	9781600000000
706	Getting Started with OAuth 2.0	82	3.50	2012-02-29	9781450000000
707	Parallel and Concurrent Programming in Haskell: Techniques for Multicore and Multithreaded Programming	322	4.54	2013-08-15	9781450000000
708	In Pursuit of the Traveling Salesman: Mathematics at the Limits of Computation	228	3.88	2012-01-16	691152705
709	ggplot2: Elegant Graphics for Data Analysis	212	4.31	2009-08-01	9780390000000
710	Distributed Operating Systems	632	3.96	1994-09-04	9780130000000
711	SciPy and NumPy: An Overview for Developers	82	2.96	2012-11-22	9781450000000
712	Scala in Depth	276	3.93	2012-05-23	\N
713	Implementation Patterns	157	3.62	2007-10-01	9780320000000
714	Networks, Crowds, and Markets: Reasoning about a Highly Connected World	727	4.17	2010-07-31	9780520000000
715	Cypherpunks: Freedom and the Future of the Internet	192	3.70	2012-11-23	9781940000000
716	Selected Writings on Computing: A Personal Perspective	362	4.25	1982-10-25	9780390000000
717	The Practice of System and Network Administration	1011	4.39	2007-06-01	9780320000000
718	Tubes: A Journey to the Center of the Internet	294	3.50	2012-05-23	9780060000000
719	Getting Started with Arduino	128	3.78	2009-03-31	9780600000000
720	The Object-Oriented Thought Process	330	3.68	2008-08-01	9780670000000
721	Foundations of Programming - Building Better Software	79	3.81	2008-03-23	\N
722	Joe Celko's SQL for Smarties: Advanced SQL Programming	840	3.95	2005-08-01	9780120000000
723	Practical C Programming	456	3.68	1997-08-11	9781570000000
724	Java in a Nutshell	1224	3.81	2005-03-25	9780600000000
725	Parsing Techniques: A Practical Guide	662	4.20	2008-01-01	9780390000000
726	The Art of Computer Programming, Volume 4, Fascicle 2: Generating All Tuples and Permutations	127	4.70	2005-02-24	9780200000000
727	The Art of Computer Programming, Volume 4, Fascicle 1: Bitwise Tricks & Techniques; Binary Decision Diagrams	260	4.73	2009-03-01	9780320000000
728	The Old New Thing: Practical Development Throughout the Evolution of Windows	517	3.92	2006-12-01	9780320000000
729	Inside the Machine	320	4.13	2006-12-08	9781590000000
730	Python in a Nutshell	695	3.88	2006-07-24	9780600000000
731	Head First Software Development	498	3.93	2007-12-27	9780600000000
732	Programming Game AI by Example	495	4.07	2004-09-30	9781560000000
733	Lex & Yacc	388	3.68	1992-10-08	9781570000000
734	Implementing Lean Software Development: From Concept to Cash	276	4.16	2006-10-01	9780320000000
735	Head First Servlets and JSP: Passing the Sun Certified Web Component Developer Exam	888	4.16	2004-08-30	9780600000000
736	Distributed Algorithms	904	4.19	1996-03-15	9781560000000
737	Why's (Poignant) Guide to Ruby	176	4.05	2007-03-23	\N
738	Perl Best Practices: Standards and Styles for Developing Maintainable Code	517	4.27	2005-07-22	9780600000000
739	HTML & XHTML: The Definitive Guide	680	3.91	2006-10-24	9780600000000
740	Lisp	611	3.98	1989-01-11	9780200000000
741	Broad Band: The Untold Story of the Women Who Made the Internet	288	4.00	2018-03-06	9780740000000
742	Gray Hat Hacking: The Ethical Hacker's Handbook	434	4.09	2004-12-01	9780070000000
743	Machine Learning	224	3.62	2016-09-30	\N
744	Once Upon an Algorithm: How Stories Explain Computing	336	3.81	2017-08-11	9780260000000
745	Feynman And Computation	462	4.42	2002-06-27	9780810000000
746	Your Code As a Crime Scene: Use Forensic Techniques to Arrest Defects, Bottlenecks, and Bad Design in Your Programs	190	3.59	2014-05-23	9781680000000
747	Python Data Science Handbook: Tools and Techniques for Developers	500	4.28	2016-12-25	9781490000000
748	Programming Elixir: Functional |> Concurrent |> Pragmatic |> Fun	287	4.33	2013-03-23	9781940000000
749	Spam Nation: The Inside Story of Organized Cybercrime Acâ‚¬â€? from Global Epidemic to Your Front Door	256	3.72	2014-11-18	9781400000000
750	C Programming Absolute Beginner's Guide	352	4.24	2013-08-02	\N
751	Assembly Language: Step-By-Step	448	4.22	1992-10-06	9780470000000
752	The Little MLer	198	3.91	1998-01-05	9780260000000
753	Lambda-Calculus and Combinators: An Introduction	345	3.80	2008-07-01	9780520000000
754	More Programming Pearls: Confessions of a Coder	224	4.03	1988-01-11	9780200000000
755	But How Do It Know? - The Basic Principles of Computers for Everyone	221	4.49	2009-07-04	9780620000000
756	Learning Spark	300	3.87	2014-07-22	9781450000000
757	Java Performance: The Definitive Guide	500	4.38	2014-05-22	9781450000000
758	Red Team Field Manual (RTFM)	96	4.22	2014-02-11	9781490000000
759	Systems Performance: Enterprise and the Cloud	735	4.47	2013-10-26	9780130000000
760	Learning Javascript Design Patterns	227	3.84	2012-05-01	\N
761	SQL Performance Explained	204	4.34	2012-07-30	9783950000000
762	Python 3 Object Oriented Programming	388	4.01	2010-07-19	9781850000000
763	The Google Resume: How to Prepare for a Career and Land a Job at Apple, Microsoft, Google, or Any Top Tech Company	280	3.77	2011-03-01	9780470000000
764	C++ Coding Standards: 101 Rules, Guidelines, and Best Practices	240	4.20	2004-11-01	76092018117
765	WindowsÂ® Internals, Part 2: Covering Windows ServerÂ® 2008 R2 and Windows 7	674	4.54	2012-10-02	9780740000000
766	The Healthy Programmer	220	3.73	2013-03-23	9781940000000
767	Practical Cryptography	385	4.18	2003-04-17	9780470000000
768	Continuous Integration: Improving Software Quality and Reducing Risk	283	3.79	2007-07-09	9780320000000
769	Sams Teach Yourself SQLAcâ€žc in 10 Minutes	242	4.02	2004-03-01	9780670000000
770	Data Structures and Algorithm Analysis in C	528	3.80	1996-09-19	9780200000000
771	The Master Switch: The Rise and Fall of Information Empires	384	3.84	2010-11-02	9780310000000
772	Bayesian Reasoning and Machine Learning	697	4.11	2012-04-01	9780520000000
773	Computer Science Illuminated	636	3.55	2006-12-01	9780760000000
774	Functional JavaScript: Introducing Functional Programming with Underscore.js	260	4.07	2013-06-17	9781450000000
1172	The Design of Everyday Things	240	4.19	2002-09-19	9780470000000
775	We Are Anonymous: Inside the Hacker World of LulzSec, Anonymous, and the Global Cyber Insurgency	512	3.94	2012-06-05	9780320000000
776	A First Course in Logic: An Introduction to Model Theory, Proof Theory, Computability, and Complexity	431	4.31	2004-09-01	9780200000000
777	Effective JavaScript: 68 Specific Ways to Harness the Power of JavaScript	240	4.32	2012-12-06	9780320000000
778	Fire in the Valley: The Making of the Personal Computer	463	4.11	1999-11-29	9780070000000
779	Practical Malware Analysis: The Hands-On Guide to Dissecting Malicious Software	800	4.43	2012-02-29	9781590000000
780	Objective-C Programming: The Big Nerd Ranch Guide	263	4.17	2011-10-18	9780320000000
781	The Art Of Prolog: Advanced Programming Techniques	437	3.79	1986-05-01	9780260000000
782	Think Stats	138	3.66	2011-07-22	9781450000000
783	Data and Reality	\N	4.05	\N	9781590000000
784	Learning SQL	289	3.86	2005-09-01	9780600000000
785	GA¶del's Proof	129	4.14	2001-10-01	9780810000000
786	Essentials of Computer Organization and Architecture	673	3.20	2003-01-01	9780760000000
787	jQuery in Action	347	3.94	2008-02-01	9781930000000
788	The Art and Science of Java	587	3.99	2007-02-01	9780320000000
789	Death March	230	3.83	2003-11-16	9780130000000
790	Programming Scala: Scalability = Functional Programming + Objects	448	3.72	2009-09-22	9780600000000
791	Compiler Construction: Principles and Practice	592	3.90	1997-01-24	9780530000000
792	Programming Clojure	304	3.82	2009-06-04	9781930000000
793	OpenGL SuperBible: Comprehensive Tutorial and Reference	1205	3.99	2007-06-01	9780320000000
794	Thinking Forth	316	3.91	2004-12-27	9780980000000
795	Linkers and Loaders	256	3.96	1999-10-25	9781560000000
796	Processing: A Programming Handbook for Visual Designers and Artists	710	4.15	2007-08-17	9780260000000
797	Designing Web Usability	432	3.80	2000-01-01	9781560000000
798	The Scheme Programming Language	295	3.94	2003-09-26	9780260000000
799	Python Essential Reference (Developer's Library)	648	4.21	2006-03-02	9780670000000
800	C Programming: A Modern Approach	832	4.26	2008-04-01	9780390000000
801	Modern Compiler Implementation in Java	512	3.47	2015-01-28	9780520000000
802	WindowsA‚Â® Internals (PRO-Developer)	1232	4.46	2009-06-17	9780740000000
803	Designing Interfaces: Patterns for Effective Interaction Design	352	3.82	2005-11-28	9780600000000
804	Theoretische Informatik - kurzgefasst	198	3.67	2001-03-01	9783830000000
805	The Manga Guide to Databases	224	4.05	2008-12-01	9781590000000
806	Randomized Algorithms	496	4.06	1995-08-01	9780520000000
807	The Haskell School of Expression: Learning Functional Programming Through Multimedia	382	3.72	2000-02-01	9780520000000
808	Rocket Surgery Made Easy: The Do-It-Yourself Guide to Finding and Fixing Usability Problems	161	4.11	2009-12-01	9780320000000
809	Artificial Intelligence: Structures and Strategies for Complex Problem Solving	928	3.69	2004-10-21	9780320000000
810	A Madman Dreams of Turing Machines	230	3.67	2006-08-22	9781400000000
811	High Performance JavaScript	242	4.05	2010-03-30	9780600000000
812	Principles of Computer System Design: An Introduction	526	3.70	2009-07-07	9780120000000
813	Algorithmic Game Theory	776	4.19	2013-12-06	9780520000000
814	Neural Networks: A Comprehensive Foundation	842	3.89	1998-07-06	9780130000000
815	Running Linux	749	3.70	1999-08-11	9781570000000
816	UNIX Network Programming, Volume 1: The Sockets Networking API	991	4.35	2003-11-24	76092025917
817	The Java Programming Language	891	3.80	2005-08-25	9780320000000
818	Computer Power and Human Reason: From Judgment to Calculation	300	4.29	1976-01-01	9780720000000
819	Programming Challenges: The Programming Contest Training Manual	364	4.04	2003-05-12	9780390000000
820	How to Solve It: Modern Heuristics	554	3.98	2004-09-21	9783540000000
821	Writing Effective Use Cases	304	3.95	2000-10-15	9780200000000
822	Concurrent Programming in Javai?1: Design Principles and Pattern	432	4.18	1999-11-04	9780200000000
823	Hello World: Being Human in the Age of Algorithms	246	4.14	2018-09-18	9780390000000
824	A Mind at Play: How Claude Shannon Invented the Information Age	384	4.15	2017-07-18	9781480000000
825	More Effective C++	336	4.33	1996-01-08	785343000000
826	The Little Prover	248	3.96	2015-07-10	9780260000000
827	The Dark Net: Inside the Digital Underworld	320	3.66	2014-08-21	9780430000000
828	Physically Based Rendering: From Theory to Implementation	1167	4.58	2010-07-12	9780120000000
829	Competitive Programming 3	447	4.62	2013-06-07	\N
830	Coding the Matrix: Linear Algebra through Computer Science Applications	528	4.32	2013-07-26	9780620000000
831	Zero to One: Notes on Startups, or How to Build the Future	195	4.16	2014-09-16	9780800000000
832	Readings in Database Systems	685	4.71	1998-01-01	9781560000000
833	The Data Warehouse Toolkit: The Complete Guide to Dimensional Modeling	464	4.12	2002-04-26	9780470000000
834	Python Crash Course: A Hands-On, Project-Based Introduction to Programming	560	4.25	2015-12-03	9781590000000
835	Data Smart: Using Data Science to Transform Information into Insight	409	4.17	2013-10-31	9781120000000
836	The Principles of Object-Oriented JavaScript	120	4.38	2014-02-07	\N
837	The UNIX Hater's Handbook: The Best of UNIX-Haters On-line Mailing Reveals Why UNIX Must Die,	329	3.68	1994-06-01	9781570000000
838	Thinking in Systems: A Primer	240	4.26	2008-12-03	9781600000000
839	The Art of Prolog: Advanced Programming Techniques	552	3.91	1994-03-10	9780260000000
840	Tcp/IP Illustrated, Volume 1: The Protocols	1017	4.60	2011-11-25	9780320000000
841	Realm of Racket: Learn to Program, One Game at a Time,	312	3.69	2013-06-25	9781590000000
842	Metamagical Themas: Questing for the Essence of Mind and Pattern	880	4.18	1996-04-05	9780470000000
843	Hadoop: The Definitive Guide	528	3.94	2009-06-12	9780600000000
844	Complexity: A Guided Tour	349	4.06	2009-04-01	9780200000000
845	Principles of Compiler Design	604	3.97	1977-03-23	9780200000000
846	Version Control with Git	297	3.89	2009-06-11	9780600000000
847	Mindstorms: Children, Computers, And Powerful Ideas	252	4.30	1993-08-04	9780470000000
848	Specification by Example	249	4.04	2011-06-03	9781620000000
849	Algorithmic Puzzles	257	4.11	2011-10-14	9780200000000
850	You Are Not a Gadget	221	3.54	2010-01-12	9780310000000
851	Smalltalk Best Practice Patterns	224	4.18	1996-10-13	9780130000000
852	Mathematics for 3D Game Programming and Computer Graphics	545	4.05	2011-06-02	8581030000000
853	Code Simplicity: The Fundamentals of Software	84	3.62	2012-04-05	9781450000000
854	Framework Design Guidelines: Conventions, Idioms, and Patterns for Reusable .NET Libraries	480	4.21	2008-10-22	9780320000000
855	Logicomix: An Epic Search for Truth	352	4.03	2009-10-05	9781600000000
856	Introduction to Modern Cryptography: Principles and Protocols	534	4.30	2007-08-31	9781580000000
857	Modern Compiler Implementation in ML	552	3.91	2004-05-26	9780520000000
858	Debugging: The 9 Indispensable Rules for Finding Even the Most Elusive Software and Hardware Problems	192	4.22	2006-11-05	9780810000000
859	Metaprogramming Ruby	296	4.33	2010-02-22	9781930000000
860	DNS and BIND	642	3.96	2006-06-02	9780600000000
861	Social Engineering: The Art of Human Hacking	382	3.82	2010-12-21	9780470000000
862	Modern Compiler Implementation in C	556	3.60	2004-05-26	9780520000000
863	Data Analysis with Open Source Tools: A Hands-On Guide for Programmers and Data Scientists	509	4.05	2010-11-28	9780600000000
864	The Art of Computer Programming, Volume 4, Fascicle 3: Generating All Combinations and Partitions	160	4.50	2005-07-01	9780200000000
865	The Agile Samurai: How Agile Masters Deliver Great Software	267	3.93	2010-03-23	\N
866	Handbook of Applied Cryptography	810	4.03	1996-10-16	9780850000000
867	Algorithmics: The Spirit of Computing	480	3.94	1992-01-23	9780200000000
868	Haskell: The Craft of Functional Programming	487	3.53	1999-03-29	9780200000000
869	WindowsÂ® Internals, Part 1: Covering Windows ServerÂ® 2008 R2 and Windows 7	754	4.43	2012-04-05	9780740000000
870	Data Structures and Algorithms in Java	800	4.09	2002-11-16	9780670000000
871	The Man Who Knew Too Much: Alan Turing and the Invention of the Computer	336	3.48	2006-11-17	9780390000000
872	Free as in Freedom: Richard Stallman's Crusade for Free Software	240	3.81	2002-03-08	9780600000000
873	The Design and Implementation of the FreeBSD Operating System	720	4.31	2004-08-01	9780200000000
874	Eloquent Ruby	413	4.35	2011-02-21	9780320000000
875	Dealers of Lightning: Xerox PARC and the Dawn of the Computer Age	480	4.13	2000-04-05	9780890000000
876	LISP in Small Pieces	514	4.28	2003-10-18	9780520000000
877	User Stories Applied: For Agile Software Development	268	3.88	2004-03-11	9780320000000
878	REST in Practice: Hypermedia and Systems Architecture	448	3.82	2010-09-24	9780600000000
879	Programming Languages: Application and Interpretation	360	4.09	\N	\N
880	Agile Estimating and Planning	330	4.09	2005-11-01	9780130000000
881	Neural Networks for Pattern Recognition	504	4.07	1996-01-18	9780200000000
882	iWoz: Computer Geek to Cult Icon: How I Invented the Personal Computer, Co-Founded Apple, and Had Fun Doing It	313	3.85	2007-10-17	9780390000000
883	Database Management Systems	1104	3.76	2002-08-14	9780070000000
884	97 Things Every Software Architect Should Know: Collective Wisdom from the Experts	222	3.60	2009-02-12	9780600000000
885	Snow Crash	480	4.03	2003-08-26	\N
886	ANSI Common Lisp	444	4.12	1996-03-23	9780130000000
887	An Introduction to Genetic Algorithms	221	3.75	1998-03-02	9780260000000
888	Writing Solid Code	288	4.09	1993-01-01	9781560000000
889	Writing Secure Code	768	4.01	2002-12-14	9780740000000
890	The Nature of Code	520	4.60	2012-12-13	9780990000000
891	Computer System Architecture	544	3.80	1992-10-29	9780130000000
892	C++ Standard Library: A Tutorial and Reference	832	4.15	1999-08-12	9780200000000
893	The Design and Analysis of Computer Algorithms	480	3.85	1974-01-11	9780200000000
894	Combinatorial Optimization: Algorithms and Complexity	528	3.98	1998-01-29	9780490000000
895	The Art of Computer Programming, Volume 4, Fascicle 0: Introduction to Combinatorial Algorithms and Boolean Functions	216	4.53	2008-05-01	9780320000000
896	Algorithms on Strings, Trees and Sequences: Computer Science and Computational Biology	556	4.05	1997-05-01	9780520000000
897	Analysis Patterns: Reusable Object Models	384	3.78	1996-10-19	9780200000000
898	The Design and Evolution of C++	480	4.29	1994-04-08	9780200000000
899	Design Patterns Explained: A New Perspective on Object-Oriented Design	480	3.87	2004-10-22	9780320000000
900	Introduction to Machine Learning	415	3.67	2004-10-01	9780260000000
901	Blockchain Revolution: How the Technology Behind Bitcoin Is Changing Money, Business, and the World	368	3.36	2016-05-10	9780670000000
902	Rise of the Robots: Technology and the Threat of a Jobless Future	352	4.03	2015-05-05	9780470000000
903	High Performance Browser Networking	400	4.52	2013-03-23	\N
904	Scrum: The Art of Doing Twice the Work in Half the Time	237	4.19	2014-09-30	9780390000000
905	Data Science for Business: What you need to know about data mining and data-analytic thinking	414	4.17	2013-08-16	9781450000000
906	The Mathematical Theory of Communication	125	4.39	1963-03-23	9780250000000
907	The Shallows: What the Internet Is Doing to Our Brains	280	3.87	2011-06-06	9780390000000
908	Object Thinking	334	3.97	2004-02-21	9780740000000
909	Scala for the Impatient	384	4.12	2012-03-16	9780320000000
910	Effective Programming: More Than Writing Code	283	3.91	2012-07-10	\N
911	Violent Python: A Cookbook for Hackers, Forensic Analysts, Penetration Testers and Security Engineers	288	4.03	2012-11-22	9781600000000
912	The Lean Startup: How Today's Entrepreneurs Use Continuous Innovation to Create Radically Successful Businesses	299	4.06	2011-09-13	9780310000000
913	Digital Design and Computer Architecture	592	4.29	2007-03-01	9780120000000
914	Design Patterns in Ruby	352	4.16	2007-12-01	9780320000000
915	Linux in a Nutshell	925	3.91	2005-08-06	9780600000000
916	Computer Vision: Algorithms and Applications	812	4.17	2010-10-19	9781850000000
917	Writing for Computer Science	270	3.98	2004-06-03	9781850000000
918	C: A Reference Manual	458	4.15	1994-12-01	9780130000000
919	Quantum Computing for Computer Scientists	384	4.13	2008-08-11	9780520000000
920	To Mock a Mockingbird and Other Logic Puzzles	256	4.13	2000-11-01	9780190000000
921	A Byte of Python	149	4.05	\N	\N
922	Discrete Mathematics with Applications	928	3.94	2003-12-22	9780530000000
923	Artificial Intelligence	640	3.82	1991-03-01	9780070000000
924	Computation: Finite and Infinite Machines (Automatic Computation)	317	4.57	1967-06-01	9780130000000
925	sed & awk	434	3.83	1997-03-23	9781570000000
926	The Inmates Are Running the Asylum: Why High Tech Products Drive Us Crazy and How to Restore the Sanity	255	3.94	2004-03-05	\N
927	Software Craftsmanship	305	4.31	2014-03-10	\N
928	You Don't Know JS: Async & Performance	296	4.28	2015-03-09	9781490000000
929	You Don't Know JS: ES6 & Beyond	278	4.37	2015-12-27	9781490000000
930	The Architecture of Open Source Applications	432	3.68	2011-05-25	9781260000000
931	Modern C++ Design: Generic Programming and Design Patterns Applied	360	4.24	2001-02-23	9780200000000
932	The Complete Software Developer's Career Guide: How to Learn Programming Languages Quickly, Ace Your Programming Interview, and Land Your Software Developer Dream Job	796	4.20	2017-07-12	\N
933	Countdown to Zero Day: Stuxnet and the Launch of the World's First Digital Weapon	406	4.12	2014-11-11	9780770000000
934	Elements of Programming Interviews: The Insiders' Guide C++	480	4.28	2012-10-11	9781480000000
935	Hacking Exposed: Network Security Secrets & Solutions	692	3.77	2005-04-19	9780070000000
936	The Codebreakers: The Comprehensive History of Secret Communication from Ancient Times to the Internet	1200	4.20	1996-12-05	9780680000000
937	Advanced Compiler Design and Implementation	856	3.90	1997-08-15	9781560000000
938	Getting Real: The Smarter, Faster, Easier Way to Build a Web Application	171	4.01	2006-03-23	\N
939	The Art of Readable Code	204	3.93	2011-11-23	9780600000000
940	Digital Design	516	3.98	2001-08-01	9780130000000
941	Language Implementation Patterns: Techniques for Implementing Domain-Specific Languages	350	3.80	2010-01-07	9781930000000
942	The Ruby Programming Language	448	4.02	2008-02-01	9780600000000
943	An Introduction to the Analysis of Algorithms	512	4.00	1995-12-10	9780200000000
944	The Web Application Hacker's Handbook: Discovering and Exploiting Security Flaws	722	4.15	2007-10-01	9780470000000
945	Python Machine Learning	454	4.30	2015-10-01	9781780000000
946	Write Great Code: Volume 1: Understanding the Machine	456	3.92	2004-11-08	9781590000000
947	Doing Data Science	375	3.74	2013-11-03	9781450000000
948	The Shellcoder's Handbook: Discovering and Exploiting Security Holes	718	4.13	2007-08-01	9780470000000
949	The Science of Programming	\N	3.90	1989-04-21	9780390000000
950	Logic in Computer Science: Modelling and Reasoning about Systems	447	3.87	2004-08-26	9780520000000
951	Interaction Design: Beyond Human-Computer Interaction	773	3.72	2007-03-01	9780470000000
952	Transaction Processing: Concepts and Techniques	1070	4.38	1992-09-15	9781560000000
953	RESTful Web Services	454	3.84	2007-05-15	9780600000000
954	Object-Oriented Software Construction (Book/CD-ROM)	1296	4.06	1997-04-03	9780140000000
955	Literate Programming	384	3.86	1992-06-01	9780940000000
956	Unix Network Programming, Volume 1: Networking APIs - Sockets and XTI	1009	4.29	1997-10-17	9780130000000
957	The Well-Grounded Rubyist	520	4.34	2009-06-04	9781930000000
958	Category Theory for Programmers	396	4.13	2018-10-21	\N
959	The Self-Taught Programmer: The Definitive Guide to Programming Professionally	301	4.05	2017-01-24	\N
960	Digital Gold: Bitcoin and the Inside Story of the Misfits and Millionaires Trying to Reinvent Money	416	4.17	2015-05-19	9780060000000
961	Haskell Programming From First Principles	1189	4.48	2015-03-23	\N
962	Regular Expressions Cookbook	510	4.09	2009-05-29	9780600000000
963	You Don't Know JS: Types & Grammar	182	4.47	2015-02-21	9781490000000
964	Introduction to Java Programming: Comprehensive Version	1301	4.08	2006-06-01	9780130000000
965	JavaScript Patterns	216	4.17	2010-09-28	9780600000000
966	Elements of Information Theory	748	4.15	2006-06-01	9780470000000
967	Practical Common LISP	499	4.14	2007-06-26	9781590000000
968	Graph Databases	224	3.66	2013-06-17	9781450000000
969	Computational Fairy Tales	204	3.99	2012-06-26	9781480000000
970	Crypto: How the Code Rebels Beat the Government--Saving Privacy in the Digital Age	368	3.98	2001-12-31	9780140000000
971	Learning the vi and Vim Editors	494	3.90	2008-07-22	9780600000000
972	Big Data: Principles and best practices of scalable realtime data systems	328	3.83	2012-09-23	9781620000000
973	NoSQL Distilled: A Brief Guide to the Emerging World of Polyglot Persistence	192	4.09	2012-08-13	9780320000000
974	UNIX and Linux System Administration Handbook	1327	4.40	2014-03-23	9780130000000
975	UNIX Power Tools	1122	4.14	1997-08-09	9781570000000
976	Silence on the Wire: A Field Guide to Passive Reconnaissance and Indirect Attacks	312	4.20	2005-04-22	9781590000000
977	Problem Solving with Algorithms and Data Structures Using Python	357	4.09	2005-09-01	9781590000000
978	Everybody Lies: Big Data, New Data, and What the Internet Can Tell Us About Who We Really Are	338	3.92	2017-05-09	9780060000000
979	The DevOps Handbook: How to Create World-Class Agility, Reliability, and Security in Technology Organizations	437	4.35	2016-10-06	9781940000000
980	Masters of Doom: How Two Guys Created an Empire and Transformed Pop Culture	339	4.25	2004-05-11	9780810000000
981	The Productive Programmer	226	3.71	2008-07-10	9780600000000
982	The Haskell Road to Logic, Maths and Programming	432	3.68	2012-03-23	9780950000000
983	Python for Data Analysis	400	4.10	2012-10-23	9781450000000
984	Land of LISP: Learn to Program in LISP, One Game at a Time,	504	4.14	2010-04-28	9781590000000
985	Programming in Scala	736	4.21	2008-01-01	9780980000000
986	Head First Object-Oriented Analysis and Design: A Brain Friendly Guide to OOA&D	600	3.96	2006-11-01	9780600000000
987	Perl Cookbook	927	4.01	2003-08-31	9780600000000
988	Cryptography and Network Security: Principles and Practice	681	4.02	2002-08-27	9780130000000
989	Spring in Action	650	3.93	2007-08-23	9781930000000
990	The Art of Invisibility: The World's Most Famous Hacker Teaches You How to Be Safe in the Age of Big Brother and Big Data	320	3.99	2017-02-14	9780320000000
991	Programming: Principles and Practice Using C++	1236	4.17	2008-12-25	9780320000000
992	The Imposter's Handbook	463	3.97	2016-09-23	\N
993	Where Wizards Stay Up Late: The Origins of the Internet	304	3.87	1998-01-21	9780680000000
994	The Go Programming Language	380	4.45	2015-08-27	9780130000000
995	The Thrilling Adventures of Lovelace and Babbage	317	4.05	2015-04-21	9780310000000
996	The Dream Machine: J.C.R. Licklider and the Revolution That Made Computing Personal	512	4.48	2002-08-27	9780140000000
997	Java 8 in Action	394	4.31	2014-08-23	\N
998	Essential Scrum: A Practical Guide to the Most Popular Agile Process	496	4.14	2012-08-05	9780140000000
999	Learning From Data: A Short Course	213	4.43	2012-03-23	9781600000000
1000	High Performance Web Sites	146	4.17	2007-09-21	9780600000000
1001	Dependency Injection in .NET	584	4.35	2011-09-28	9781940000000
1002	Introduction to Functional Programming	293	4.13	\N	9780130000000
1003	Pattern Classification	688	4.02	2000-11-09	9780470000000
1004	Real-Time Rendering	1027	4.48	2008-07-25	9781570000000
1005	Kingpin: How One Hacker Took Over the Billion-Dollar Cybercrime Underground	288	3.94	2011-02-22	9780310000000
1006	Practical Foundations for Programming Languages	582	4.03	2012-01-30	\N
1007	The Golden Ticket: P, Np, and the Search for the Impossible	176	3.60	2013-03-31	9780690000000
1008	xUnit Test Patterns: Refactoring Test Code	883	3.92	2007-05-01	9780130000000
1009	Computational Geometry: Algorithms and Applications	367	4.05	2000-02-18	9783540000000
1010	Head First C#	714	3.92	2007-12-03	9780600000000
1011	Programming Erlang	519	3.97	2007-07-18	9781930000000
1012	C Primer Plus	959	4.10	2004-11-23	752063000000
1014	Dive Into Python	413	3.96	2004-11-05	9781590000000
1015	Java Puzzlers: Traps, Pitfalls, and Corner Cases	282	4.20	2005-09-01	9780320000000
1016	Learning the bash Shell	333	3.89	2005-04-08	9780600000000
1017	Practices of an Agile Developer: Working in the Real World	189	3.88	2006-04-01	9780970000000
1018	A New Kind of Science	1264	3.56	2002-05-01	9781580000000
1019	The Computational Beauty of Nature: Computer Explorations of Fractals, Chaos, Complex Systems, and Adaptation	514	4.34	2000-01-27	9780260000000
1020	Introduction to Algorithms: A Creative Approach	478	4.23	1989-01-11	9780200000000
1021	The Art of Multiprocessor Programming	508	3.96	2008-03-01	9780120000000
1022	An Introduction to Information Theory: Symbols, Signals and Noise	306	3.95	1980-11-01	9780490000000
1023	The Book of Why: The New Science of Cause and Effect	432	4.01	2018-05-15	9780470000000
1024	Selected Papers on Computer Science	276	3.88	2004-11-15	9781880000000
1025	Software Estimation: Demystifying the Black Art	308	4.03	2006-03-04	9780740000000
1026	An Introduction to Database Systems	1040	3.93	2003-08-01	9780320000000
1027	Programming Python	1552	3.96	2006-08-01	9780600000000
1028	Object-Oriented Analysis and Design with Applications	720	3.90	2007-04-01	9780200000000
1029	Data Mining: Practical Machine Learning Tools and Techniques	525	3.87	2005-06-01	9780120000000
1030	Make Your Own Neural Network	252	4.36	2016-03-29	\N
1031	The Effective Engineer: How to Leverage Your Efforts In Software Engineering to Make a Disproportionate and Meaningful Impact	260	4.30	2015-03-19	9781000000000
1032	The Little Book of Semaphores: The Ins and Outs of Concurrency Control and Common Mistakes	294	4.41	2009-03-20	9781440000000
1033	Neural Networks and Deep Learning	\N	4.49	2013-11-25	\N
1034	How Google Works	305	4.05	2014-09-23	\N
1035	Seven Concurrency Models in Seven Weeks: When Threads Unravel	267	3.84	2014-02-25	9781940000000
1036	Think Complexity: Complexity Science and Computational Modeling	160	3.89	2012-03-09	9781450000000
1037	Introduction to Computation and Programming Using Python	268	4.20	2013-01-18	9780260000000
1038	Mining of Massive Datasets	326	4.37	2011-12-30	9781110000000
1039	About Face 3: The Essentials of Interaction Design	610	4.04	2007-05-01	9780470000000
1040	Computability and Logic	350	4.01	2007-10-01	9780520000000
1041	Pearls of Functional Algorithm Design	277	4.18	2010-11-01	9780520000000
1042	Reversing: Secrets of Reverse Engineering	624	4.03	2005-04-15	9780760000000
1043	An Introduction to Formal Language and Automata	415	3.80	2006-02-17	9780760000000
1044	Effective STL: 50 Specific Ways to Improve Your Use of the Standard Template Library	288	4.20	2001-06-16	9780200000000
1045	Just for Fun: The Story of an Accidental Revolutionary	288	3.91	2002-06-04	9780070000000
1046	Cryptography Engineering: Design Principles and Practical Applications	353	4.18	2010-03-08	9780470000000
1047	The Art of Intrusion: The Real Stories Behind the Exploits of Hackers, Intruders and Deceivers	270	3.88	2006-01-01	9780470000000
1048	Life 3.0: Being Human in the Age of Artificial Intelligence	384	4.08	2017-08-29	9780450000000
1049	Machine Learning: A Probabilistic Perspective	1104	4.37	2012-08-24	9780260000000
1050	You Don't Know JS: this & Object Prototypes	174	4.46	2014-07-27	9781490000000
1051	Probability and Computing: Randomized Algorithms and Probabilistic Analysis	370	4.09	2005-03-01	9780520000000
1052	The Second Machine Age: Work, Progress, and Prosperity in a Time of Brilliant Technologies	336	3.95	2016-01-25	9780390000000
1053	Our Final Invention: Artificial Intelligence and the End of the Human Era	336	3.75	2013-10-01	9780310000000
1054	Automate This: How Algorithms Came to Rule Our World	256	3.83	2012-08-30	9781590000000
1055	The Essential Turing: Seminal Writings in Computing, Logic, Philosophy, Artificial Intelligence, and Artificial Life Plus the Secrets of Eni	622	4.19	2013-06-24	9780200000000
1056	How to Prove It: A Structured Approach	384	4.26	2006-03-01	9780520000000
1057	How Google Tests Software	281	3.77	2012-04-02	9780320000000
1058	Lauren Ipsum	150	3.90	2011-12-03	\N
1059	Basic Category Theory for Computer Scientists	100	3.54	1991-08-07	9780260000000
1060	Python Cookbook	706	4.13	2013-05-29	9781450000000
1061	Mastering Bitcoin: Unlocking Digital Cryptocurrencies	298	4.32	2014-12-27	9781450000000
1062	Facts and Fallacies of Software Engineering	216	3.95	2002-11-07	9780320000000
1063	Metasploit: The Penetration Tester's Guide	328	4.04	2011-07-22	9781590000000
1064	Seven Databases in Seven Weeks: A Guide to Modern Databases and the NoSQL Movement	352	4.02	2012-05-18	9781930000000
1065	The Most Human Human: What Talking with Computers Teaches Us About What It Means to Be Alive	303	3.93	2011-03-01	9780390000000
1066	Domain-Specific Languages	597	3.87	2011-03-23	9780320000000
1067	Numerical Recipes in C: The Art of Scientific Computing	1020	4.17	1992-10-30	9780520000000
1068	Things a Computer Scientist Rarely Talks About	257	3.98	2003-08-01	9781580000000
1069	Advanced Topics in Types and Programming Languages	588	3.92	2004-12-23	9780260000000
1070	The Emperor's New Mind: Concerning Computers, Minds and the Laws of Physics	640	3.86	2002-12-12	9780190000000
1071	The Seasoned Schemer	224	4.30	1995-12-21	9780260000000
1072	Dreaming in Code: Two Dozen Programmers, Three Years, 4,732 Bugs, and One Quest for Transcendent Software	416	3.69	2007-01-16	9781400000000
1073	Machine Learning for Hackers	322	3.72	2012-02-23	\N
1074	The Universal Computer: The Road from Leibniz to Turing	257	4.12	2000-10-17	9780390000000
1075	On Lisp: Advanced Techniques for Common Lisp	413	4.31	1993-09-09	9780130000000
1076	UML Distilled: A Brief Guide to the Standard Object Modeling Language	208	3.78	2003-09-25	9780320000000
1077	Practical Vim: Edit Text at the Speed of Thought	300	4.47	2012-09-23	9781930000000
1078	Probabilistic Graphical Models: Principles and Techniques	1231	4.21	2009-08-01	9780260000000
1079	C++ Primer Plus	1202	4.05	2004-11-15	752063000000
1080	Game Engine Architecture	860	4.33	2009-06-15	9781570000000
1081	Algorithms in a Nutshell	343	3.88	2008-10-01	9780600000000
1082	Data Mining: Concepts and Techniques (The Morgan Kaufmann Series in Data Management Systems)	772	3.89	2006-03-01	9781560000000
1083	Cryptonomicon	1139	4.25	2002-11-01	9780060000000
1084	Computer Science: An Overview	599	3.77	2006-02-01	9780320000000
1085	Think Like a Programmer: An Introduction to Creative Problem Solving	233	3.90	2012-08-08	9781590000000
1086	Data Structures and Algorithms	448	3.87	1983-01-11	9780200000000
1087	Programming in Haskell	171	4.00	2007-01-15	9780520000000
1088	The Nature of Computation	1032	4.59	2011-09-26	9780200000000
1089	Quantum Computation and Quantum Information	700	4.31	2000-10-23	9780520000000
1090	The Singularity is Near: When Humans Transcend Biology	652	3.94	2006-09-26	9780140000000
1091	Security Engineering: A Guide to Building Dependable Distributed Systems	1040	4.20	2008-04-01	9780470000000
1092	A Philosophy of Software Design	190	4.12	2018-04-06	9781730000000
1093	Computer Science Distilled: Learn the Art of Solving Computational Problems	\N	4.10	2017-01-17	9781000000000
1094	Soft Skills: The Software Developer's Life Manual	470	3.92	\N	\N
1095	How to Solve It: A New Aspect of Mathematical Method	288	4.16	2015-09-25	9780690000000
1096	Game Programming Patterns	300	4.51	2011-01-01	9781430000000
1097	You Don't Know JS: Up & Going	72	4.31	2015-04-23	9781490000000
1098	Reinforcement Learning: An Introduction	322	4.45	1998-02-26	9780260000000
1099	Learn Python The Hard Way	210	3.89	\N	\N
1100	Data and Goliath: The Hidden Battles to Collect Your Data and Control Your World	448	4.03	2016-02-08	9780390000000
1101	A Tour of C++	192	4.24	2013-10-03	9780320000000
1102	JavaScript and jQuery: Interactive Front-End Web Development	640	4.35	2014-06-30	9781120000000
1103	The Art of Computer Programming, Volume 4A: Combinatorial Algorithms, Part 1	912	4.54	2011-01-22	9780200000000
1104	Agile Principles, Patterns, and Practices in C#	732	4.32	2006-07-30	9780130000000
1105	Agile Web Development with Rails: A Pragmatic Guide	558	3.91	2005-07-28	9780980000000
1106	Elements of the Theory of Computation	384	3.84	1997-08-17	9780130000000
1107	Digital Image Processing	793	4.01	2001-11-09	9780200000000
1108	Secrets of the JavaScript Ninja	370	4.17	2013-01-14	9781930000000
1109	On Intelligence	261	4.13	2005-08-01	9780810000000
1110	Secrets and Lies: Digital Security in a Networked World	401	3.89	2004-01-30	9780470000000
1111	Software Architecture in Practice	560	3.72	2003-04-09	785342000000
1112	The Pattern on the Stone: The Simple Ideas that Make Computers Work	176	4.04	1999-10-08	9780470000000
1113	Software Engineering: A Practitioner's Approach	793	3.70	2004-03-01	9780070000000
1114	Foundations of Computer Science: C Edition	800	4.01	1994-10-15	9780720000000
1115	Python Programming: An Introduction to Computer Science	517	4.00	2003-12-01	9781890000000
1116	Introduction to the Design and Analysis of Algorithms	565	3.97	2011-10-09	9780130000000
1117	How Computers Work	464	3.89	2005-11-19	9780790000000
1118	Thinking in Java	1482	4.16	2006-02-20	9780130000000
1119	From Mathematics to Generic Programming	320	4.15	2014-10-29	9780130000000
1120	The Reasoned Schemer	176	4.28	2005-10-14	9780260000000
1121	Essentials of Programming Languages	389	3.93	2001-01-29	9780260000000
1122	Algorithms Plus Data Structures Equals Programs (Prentice-Hall series in automatic computation)	400	4.22	1975-11-11	9780130000000
1123	How Linux Works: What Every Superuser Should Know	368	4.10	2004-05-24	9781590000000
1124	Fluent Python: Clear, Concise, and Effective Programming	792	4.67	2015-08-20	9781490000000
1125	C++ Primer	885	4.19	2005-02-24	9780200000000
1126	Computer Graphics: Principles and Practice	9998	4.16	1995-08-14	9780200000000
1127	Concepts of Programming Languages	670	3.71	1998-08-01	9780200000000
1128	The Joy of Clojure	328	4.18	2011-03-28	9781940000000
1129	The Art of Unit Testing: With Examples in .NET	320	4.10	2009-07-05	9781930000000
1130	Java: How to Program	1568	3.85	2004-08-14	9780130000000
1131	Database Systems: The Complete Book	1119	3.77	2001-10-02	9780130000000
1132	How to Create a Mind: The Secret of Human Thought Revealed	336	3.96	2012-11-13	9780670000000
1133	Programming Ruby: The Pragmatic Programmers' Guide	828	4.05	2004-10-11	9780970000000
1134	The Cuckoo's Egg: Tracking a Spy Through the Maze of Computer Espionage	399	4.21	2005-09-13	9781420000000
1135	The Elements of Programming Style	168	4.18	1988-06-01	9780070000000
1136	You Don't Know JS: Scope and Closures	98	4.54	2014-03-24	9781450000000
1137	C# in Depth	554	4.48	2010-11-22	9781940000000
1138	Weapons of Math Destruction: How Big Data Increases Inequality and Threatens Democracy	259	3.87	2016-09-06	9780550000000
1139	Data Science from Scratch: First Principles with Python	330	3.91	2015-04-14	\N
1140	C++: How to Program	1536	3.94	2004-12-01	9780130000000
1141	Implementing Domain-Driven Design	656	4.06	2013-02-16	9780320000000
1142	Let Over Lambda	384	4.04	2008-04-02	9781440000000
1143	Understanding the Linux Kernel	923	4.06	2005-11-24	9780600000000
1144	An Introduction to Functional Programming Through Lambda Calculus	336	4.13	2011-08-18	9780490000000
1145	Apprenticeship Patterns: Guidance for the Aspiring Software Craftsman	176	4.11	2009-10-22	9780600000000
1146	Elements of Programming	262	4.01	2009-06-01	9780320000000
1147	Engineering a Compiler	801	3.97	2003-11-10	9781560000000
1148	In the Beginning...Was the Command Line	160	3.79	2009-10-13	\N
1149	Introduction to Information Retrieval	482	4.20	2008-07-01	9780520000000
1150	Programming Perl	1092	4.05	2000-07-24	9780600000000
1151	Programming the Universe: A Quantum Computer Scientist Takes on the Cosmos	240	4.00	2006-03-14	9781400000000
1152	Hands-On Machine Learning with Scikit-Learn and TensorFlow	450	4.55	2017-04-09	\N
1153	Rapid Development: Taming Wild Software Schedules	674	3.96	1996-07-09	9781560000000
1154	Foundations of Statistical Natural Language Processing	679	4.16	1999-05-28	9780260000000
1155	Out of Their Minds: The Lives and Discoveries of 15 Great Computer Scientists	291	3.80	1998-07-02	9780390000000
1156	Effective Python: 59 Specific Ways to Write Better Python	227	4.26	2015-03-08	9780130000000
1157	Big Data: A Revolution That Will Transform How We Live, Work, and Think	242	3.71	2013-03-05	9780540000000
1158	Effective Modern C++: 42 Specific Ways to Improve Your Use of C++11 and C++14	334	4.52	2014-12-12	9781490000000
1159	Real World Haskell: Code You Can Believe In	720	3.93	2008-12-02	9780600000000
1160	Algorithms Unlocked	237	4.17	2013-05-15	9781300000000
1161	Turing's Cathedral: The Origins of the Digital Universe	505	3.55	2012-03-06	9780310000000
1162	The Art of UNIX Programming	560	4.17	2003-10-03	9780130000000
1163	Database System Concepts	1142	3.77	2005-06-01	9780070000000
1164	Refactoring to Patterns	400	4.03	2004-08-15	785342000000
1165	Site Reliability Engineering: How Google Runs Production Systems	552	4.23	2016-04-16	9781490000000
1166	The Linux Command Line	480	4.36	2012-01-14	9781590000000
1167	The New Turing Omnibus: 66 Excursions In Computer Science	480	3.88	1993-04-01	9780720000000
1168	JavaScript: The Definitive Guide	1032	4.02	2006-08-24	9780600000000
1169	Linux Kernel Development	440	4.29	2010-06-25	9780670000000
1170	Programming Language Pragmatics	875	3.96	2005-11-07	9780130000000
1173	The Innovators: How a Group of  Hackers, Geniuses and Geeks Created the Digital Revolution	528	4.08	2014-10-07	9781480000000
1174	The Soul of a New Machine	293	4.11	2000-06-01	9780320000000
1175	The Elements of Statistical Learning: Data Mining, Inference, and Prediction	552	4.37	2003-09-02	9780390000000
1176	The Computer and the Brain	112	3.90	2000-07-11	9780300000000
1177	Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions	736	4.07	2003-10-20	785342000000
1178	Release It,: Design and Deploy Production-Ready Software (Pragmatic Programmers)	326	4.21	2007-04-06	9780980000000
1179	Computational Complexity	579	4.27	2009-05-01	9780520000000
1180	Automate the Boring Stuff with Python: Practical Programming for Total Beginners	479	4.25	2015-05-01	9781590000000
1181	HTML and CSS: Design and Build Websites	514	4.34	2011-11-08	9781120000000
1182	Speech and Language Processing: An Introduction to Natural Language Processing, Computational Linguistics and Speech Recognition	934	4.17	2000-01-26	9780130000000
1183	Paradigms of Artificial Intelligence Programming: Case Studies in Common LISP	946	4.32	1991-10-15	9781560000000
1184	Agile Software Development, Principles, Patterns, and Practices	552	4.26	2002-10-25	9780140000000
1185	Operating Systems: Three Easy Pieces	686	4.72	2012-08-18	\N
1186	Software Engineering (International Computer Science Series)	759	3.75	2004-05-10	9780320000000
1187	Alan Turing: The Enigma	608	3.80	2000-03-01	9780800000000
1188	Expert C Programming: Deep C Secrets	384	4.31	1994-06-24	9780130000000
1189	Operating Systems Design and Implementation	1088	4.03	2006-01-01	9780130000000
1190	Computer Organization and Architecture: Designing for Performance	815	4.05	2002-05-23	9780130000000
1191	Learning Perl	312	3.98	2005-07-21	9780600000000
1192	Extreme Programming Explained: Embrace Change (The XP Series)	224	4.04	2004-11-26	9780320000000
1193	An Introduction to Statistical Learning: With Applications in R	426	4.61	2017-09-01	9781460000000
1194	The Design of Design: Essays from a Computer Scientist	421	3.75	2010-03-26	9780200000000
1195	97 Things Every Programmer Should Know: Collective Wisdom from the Experts	258	3.65	2010-02-19	9780600000000
1196	The Art of Deception: Controlling the Human Element of Security	352	3.76	2003-10-17	9780760000000
1197	Natural Language Processing with Python	504	4.14	2009-07-07	9780600000000
1198	Accelerated C++: Practical Programming by Example	352	4.06	2000-08-24	785343000000
1199	Distributed Systems: Concepts and Design	1047	3.59	2011-05-07	9780130000000
1200	Practical Object Oriented Design in Ruby	247	4.55	2012-08-19	9780320000000
1201	Fundamentals of Database Systems	1139	3.81	2006-03-07	9780320000000
1202	Distributed Systems: Principles and Paradigms	686	3.90	2006-10-01	9780130000000
1203	The Psychology of Computer Programming	292	4.10	2005-10-21	9780930000000
1205	The Design of the UNIX Operating System	471	4.20	1986-06-06	9780130000000
1206	Programming Interviews Exposed: Secrets to Landing Your Next Job (Programmer to Programmer)	237	3.96	2007-04-30	9780470000000
1207	Pragmatic Thinking and Learning: Refactor Your Wetware	251	4.12	2008-09-01	9781930000000
1208	Learn You a Haskell for Great Good,	176	4.32	\N	\N
1209	Designing Data-Intensive Applications	562	4.72	\N	\N
1210	The Master Algorithm: How the Quest for the Ultimate Learning Machine Will Remake Our World	352	3.80	2015-09-22	9780470000000
1211	Hacking: The Art of Exploitation	241	4.13	2004-10-08	9781590000000
1212	Pattern Recognition and Machine Learning	738	4.28	2011-04-06	9780390000000
1213	Peopleware: Productive Projects and Teams	245	4.16	1999-01-01	9780930000000
1214	The Art of Computer Programming, Volume 2: Seminumerical Algorithms	784	4.39	1997-11-14	9780200000000
1215	Cracking the Coding Interview: 150 Programming Questions and Solutions	500	4.34	2011-08-01	9781470000000
1217	Learning Python	1214	3.94	2003-12-30	9780600000000
1218	Hackers: Heroes of the Computer Revolution	464	4.13	2001-01-01	9780140000000
1219	Deep Learning	787	4.47	2016-03-23	\N
1220	A Discipline of Programming	256	4.27	1976-03-29	9780130000000
1221	Algorithm Design	864	4.12	2005-03-26	9780320000000
1222	The Art of Computer Programming: Volume 3: Sorting and Searching	800	4.38	1998-05-04	785343000000
1223	Computer Architecture: A Quantitative Approach	704	4.08	2006-11-03	9780120000000
1224	Growing Object-Oriented Software, Guided by Tests	345	4.17	2009-10-01	9780320000000
1225	Advanced Programming in the UNIX Environment	768	4.31	1992-06-30	9780200000000
1226	Algorithms	320	4.21	2006-09-13	9780070000000
\.


--
-- Data for Name: books_publishers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books_publishers (books_book_id, publishers_publisher_id) FROM stdin;
985	37
985	200
42	141
370	3
985	241
368	47
528	168
780	66
480	10
165	169
948	138
910	62
639	100
475	165
288	70
131	183
543	134
714	61
949	43
1222	228
942	200
413	96
291	218
673	119
952	192
717	27
272	188
502	176
985	133
879	230
440	226
642	56
249	64
771	103
698	92
270	230
871	221
481	94
48	139
1072	100
800	109
831	70
317	138
1027	23
335	200
563	91
978	196
434	24
1144	36
1173	61
756	62
1160	218
1001	115
863	78
318	223
282	98
684	139
319	65
173	34
829	169
163	12
998	61
1051	50
112	11
459	31
369	148
371	2
156	79
968	76
1161	139
977	116
597	73
119	20
723	152
1043	174
447	28
527	78
343	211
205	55
117	115
812	68
658	25
773	96
316	200
1071	174
1132	220
1154	235
569	3
1100	55
1140	14
240	233
989	208
951	92
698	53
1076	26
531	51
501	187
1005	104
513	27
801	127
818	190
900	127
725	17
354	16
1147	220
865	139
877	95
536	14
1051	174
538	74
830	126
439	181
401	222
532	27
982	57
415	126
770	241
988	160
926	156
954	72
269	216
787	116
368	109
1022	210
269	57
796	51
1161	137
158	200
885	198
47	4
398	73
1048	155
1155	85
138	5
671	1
1145	106
897	202
303	78
832	202
197	12
1164	91
1182	64
120	103
191	157
328	36
173	102
546	54
554	117
466	30
696	84
337	16
529	17
1039	186
258	198
1032	78
781	80
1043	58
858	10
747	156
469	158
461	102
430	116
931	141
342	46
342	51
1126	73
447	236
\.


--
-- Data for Name: borrowed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.borrowed (book_id, czlowieki_id, date_borrowed, borrow_term) FROM stdin;
36	860	2020-09-16	2021-02-18
10	836	2021-02-01	2020-08-26
22	372	2021-03-08	2020-09-04
2	344	2021-03-16	2021-04-16
18	292	2021-02-25	2020-12-25
2	143	2021-01-25	2021-06-07
30	931	2020-11-09	2021-05-26
23	598	2021-05-05	2021-04-03
36	915	2020-11-30	2021-05-08
22	51	2020-09-29	2020-07-26
17	619	2020-07-09	2020-09-02
22	117	2020-07-19	2020-07-22
19	68	2020-10-02	2020-06-18
30	313	2021-03-30	2021-03-08
32	75	2020-12-13	2021-02-25
11	724	2021-01-28	2021-02-15
31	803	2021-01-16	2020-07-09
23	998	2020-06-14	2021-01-09
27	194	2020-06-14	2021-04-10
30	914	2020-09-09	2020-11-17
13	889	2020-07-14	2020-09-05
35	509	2021-03-12	2020-10-12
17	748	2021-04-05	2020-12-27
19	257	2020-09-19	2021-02-03
35	482	2020-10-23	2020-07-10
3	101	2020-08-11	2020-08-03
32	251	2021-02-14	2020-08-20
5	757	2021-06-08	2021-01-09
9	463	2020-08-26	2020-09-02
20	845	2020-11-24	2020-10-27
22	779	2020-06-27	2020-12-29
7	212	2020-07-15	2020-07-31
36	349	2020-12-24	2020-10-09
26	903	2020-06-19	2020-10-26
11	400	2020-11-25	2021-05-12
21	766	2020-11-21	2020-09-13
22	36	2020-10-06	2020-09-23
28	360	2021-05-18	2020-10-12
20	789	2021-01-27	2021-05-10
5	553	2020-10-04	2021-03-11
36	192	2021-04-20	2021-04-28
37	785	2020-12-09	2020-12-05
4	796	2020-12-19	2020-06-26
23	133	2021-03-12	2020-12-22
28	659	2020-12-27	2020-09-08
24	786	2021-06-03	2021-04-13
33	972	2020-12-01	2020-07-28
31	307	2021-05-25	2021-02-12
17	795	2020-12-21	2020-12-14
21	916	2021-02-18	2020-11-05
32	267	2021-01-14	2021-06-03
27	472	2021-04-28	2020-08-14
18	441	2020-12-06	2021-03-06
34	496	2020-09-12	2021-05-08
6	243	2020-07-07	2021-01-17
35	672	2021-05-24	2020-08-26
9	533	2021-02-20	2021-02-14
37	192	2020-08-18	2021-05-08
31	933	2020-06-23	2020-12-21
28	814	2021-01-06	2020-10-12
35	207	2021-03-29	2020-09-10
18	122	2021-02-18	2021-03-29
15	46	2020-09-01	2020-09-01
35	910	2020-10-04	2021-03-22
29	271	2021-01-17	2021-04-16
34	290	2020-12-13	2021-01-03
27	993	2020-06-29	2021-05-16
36	395	2021-05-08	2020-06-18
18	296	2020-12-01	2021-02-28
17	397	2020-09-26	2020-11-18
33	750	2021-03-28	2020-08-12
13	795	2020-11-27	2021-02-20
9	476	2021-03-04	2020-08-04
29	643	2021-05-06	2020-07-09
15	847	2021-03-08	2021-04-17
3	597	2021-03-25	2021-02-22
19	317	2020-08-12	2020-08-07
35	414	2020-09-09	2020-10-15
18	695	2020-09-19	2020-06-29
14	988	2021-02-02	2020-06-30
24	266	2021-03-11	2021-05-07
37	987	2021-05-27	2020-11-05
12	443	2020-07-16	2020-12-06
23	370	2020-08-30	2020-09-14
4	395	2020-09-01	2021-04-15
37	644	2020-10-25	2020-09-13
33	960	2020-09-08	2020-08-05
26	984	2021-04-26	2021-01-07
23	376	2020-06-09	2020-08-03
4	716	2020-07-01	2021-04-10
36	284	2020-12-23	2020-11-24
36	603	2021-03-06	2020-11-11
17	729	2021-01-12	2020-08-12
29	604	2020-09-04	2020-09-26
35	960	2020-11-24	2021-06-04
5	159	2020-09-16	2020-09-19
15	647	2020-06-25	2020-08-08
15	74	2021-02-14	2020-07-29
22	570	2020-10-05	2021-02-03
36	943	2021-03-27	2020-10-31
12	476	2020-10-14	2021-03-29
7	184	2021-01-02	2020-06-10
28	710	2020-12-27	2021-05-30
5	299	2020-10-24	2021-01-21
35	931	2021-01-25	2020-08-09
24	104	2020-12-29	2020-08-15
21	788	2021-02-15	2021-01-19
3	89	2021-01-15	2021-04-11
27	430	2020-07-13	2021-02-22
24	627	2020-12-07	2020-07-27
31	617	2020-09-01	2020-07-12
17	447	2020-06-24	2021-04-07
17	986	2021-04-25	2020-11-22
29	445	2020-11-18	2021-05-29
5	921	2021-05-24	2020-09-02
16	621	2020-10-21	2020-07-23
12	561	2021-04-18	2020-11-26
36	155	2021-04-13	2020-07-17
4	754	2021-02-03	2020-07-29
35	179	2021-02-22	2021-05-09
3	601	2021-03-15	2020-07-08
5	700	2021-01-10	2020-06-29
20	547	2020-06-19	2020-06-14
31	798	2021-04-17	2020-12-22
3	314	2020-11-07	2021-03-15
27	529	2021-04-05	2021-05-17
37	727	2020-07-01	2021-05-31
33	955	2020-07-09	2020-09-18
12	570	2020-10-16	2020-10-26
3	369	2020-08-17	2021-05-19
34	807	2020-12-04	2020-09-04
18	3	2021-05-21	2020-09-22
31	909	2020-07-11	2021-05-31
11	132	2021-05-01	2021-03-06
10	773	2020-08-05	2020-06-26
22	789	2021-04-21	2021-06-06
2	565	2020-12-21	2020-10-01
29	113	2020-11-20	2020-07-31
26	895	2021-04-28	2020-10-10
12	376	2020-09-12	2021-04-17
11	551	2020-09-06	2020-11-03
23	213	2020-12-30	2020-09-05
9	700	2020-10-26	2020-12-20
17	913	2021-02-11	2020-06-14
11	386	2021-01-07	2020-06-11
4	445	2021-03-20	2021-02-04
34	762	2020-07-06	2020-11-24
24	812	2020-08-08	2020-11-29
32	193	2020-06-18	2020-06-20
37	483	2021-01-12	2020-09-22
18	450	2020-11-30	2020-07-18
34	317	2021-01-20	2021-01-13
30	820	2021-01-01	2020-12-26
6	19	2020-11-11	2021-05-07
11	494	2021-05-04	2020-10-05
10	710	2021-01-13	2021-05-20
25	37	2021-05-28	2021-06-05
2	767	2020-07-16	2021-03-10
32	543	2020-07-15	2021-04-18
16	437	2020-09-26	2020-07-13
9	995	2021-04-27	2020-06-27
5	877	2020-12-31	2020-11-15
16	281	2021-05-12	2021-01-04
2	82	2020-07-18	2020-11-10
13	599	2021-05-15	2020-09-11
21	523	2020-12-23	2021-02-27
18	202	2020-10-17	2020-09-29
33	941	2020-10-24	2020-10-05
20	715	2021-03-15	2020-07-08
9	687	2021-03-19	2020-12-03
31	243	2021-01-13	2020-10-13
11	379	2021-05-20	2021-04-17
33	180	2020-11-01	2021-01-04
11	252	2020-07-10	2021-03-20
1	238	2021-01-10	2021-01-28
13	76	2020-07-02	2021-01-18
29	812	2021-01-23	2020-12-27
33	961	2020-08-24	2021-06-05
18	848	2021-03-05	2021-02-25
18	719	2021-05-21	2021-02-16
21	723	2020-06-22	2021-01-26
5	894	2021-04-10	2020-11-01
30	319	2020-12-15	2020-11-28
25	270	2020-10-16	2021-04-26
4	79	2021-01-31	2021-01-20
5	263	2021-05-13	2020-07-14
25	286	2021-03-26	2020-12-25
10	757	2021-02-21	2021-01-11
21	113	2021-03-07	2020-08-31
23	444	2020-12-17	2020-10-22
7	335	2021-01-20	2021-03-21
12	289	2021-02-19	2020-11-18
34	599	2020-10-10	2021-04-21
25	210	2020-08-30	2021-04-20
32	141	2021-03-16	2021-01-17
13	723	2020-09-08	2020-07-06
14	843	2020-08-21	2020-10-15
20	820	2020-12-16	2020-10-09
13	372	2020-09-09	2020-12-22
10	835	2021-03-14	2020-10-16
17	354	2021-01-21	2020-12-11
14	726	2021-02-17	2020-10-11
29	999	2020-08-27	2021-02-06
6	462	2020-09-29	2021-03-10
12	184	2020-07-22	2021-04-17
2	864	2021-04-07	2020-10-08
24	83	2020-07-07	2020-10-23
18	6	2020-09-09	2020-10-20
6	855	2021-05-01	2021-03-04
21	106	2020-12-30	2021-01-25
7	761	2020-10-18	2021-03-16
37	965	2020-08-07	2020-12-06
33	755	2020-12-24	2020-07-09
20	223	2021-05-22	2021-01-21
14	567	2020-11-10	2021-03-10
6	619	2020-08-24	2021-04-06
9	483	2021-01-17	2021-01-29
32	610	2020-10-15	2021-01-12
21	698	2020-08-18	2021-03-17
23	221	2021-05-29	2020-06-18
32	398	2020-11-24	2021-03-01
11	775	2020-09-02	2021-04-30
7	550	2021-02-22	2021-06-01
6	42	2021-01-12	2020-09-18
3	406	2021-05-24	2021-02-15
20	790	2020-10-08	2020-12-19
6	158	2021-04-05	2021-01-08
12	149	2020-09-22	2020-10-06
23	358	2021-04-28	2021-01-31
25	129	2020-12-24	2020-10-19
37	611	2021-04-25	2021-03-07
1	495	2021-01-25	2020-09-01
2	668	2021-05-13	2021-02-17
22	540	2021-04-27	2021-05-21
17	41	2020-07-03	2020-12-16
25	25	2020-06-29	2020-10-18
19	646	2020-07-13	2020-08-24
26	280	2021-04-09	2020-12-27
35	670	2021-05-18	2021-05-19
25	532	2021-02-24	2020-12-07
32	459	2020-12-03	2020-08-05
17	384	2020-11-13	2021-05-28
15	246	2021-04-22	2020-06-18
31	434	2020-06-11	2021-05-25
24	51	2021-01-26	2020-06-24
17	931	2020-09-11	2020-09-03
23	154	2020-10-02	2020-09-25
1	50	2021-04-23	2021-05-15
12	492	2021-01-21	2020-10-24
2	290	2020-07-10	2020-09-06
22	72	2021-03-02	2021-03-05
34	543	2020-06-26	2020-12-13
34	530	2020-07-19	2021-03-23
20	411	2021-02-06	2020-07-01
4	96	2020-06-24	2021-01-03
32	134	2020-06-13	2020-08-06
28	994	2021-03-26	2021-03-12
13	467	2020-07-02	2021-02-27
36	176	2021-06-04	2021-03-12
22	245	2021-03-15	2021-05-19
25	522	2021-05-04	2021-03-18
25	985	2020-11-11	2020-11-10
17	911	2021-05-20	2020-06-23
9	340	2021-05-16	2020-10-17
16	864	2021-05-20	2021-05-30
21	750	2020-09-04	2020-11-19
30	824	2020-10-28	2021-05-20
7	563	2020-11-13	2021-02-09
10	332	2021-01-04	2021-03-21
11	343	2020-10-19	2020-08-18
32	477	2021-03-24	2020-11-23
37	32	2021-01-06	2020-10-10
20	416	2020-08-02	2020-06-22
2	438	2021-05-14	2020-07-19
5	972	2021-05-17	2020-08-19
26	158	2021-06-07	2020-08-14
25	734	2021-01-11	2021-03-23
2	36	2020-10-06	2021-02-03
6	204	2020-09-29	2021-05-10
3	74	2020-12-05	2021-01-01
15	544	2020-08-20	2020-11-18
8	928	2021-05-17	2020-12-16
27	518	2020-07-04	2021-04-16
10	276	2021-03-06	2020-10-23
21	372	2020-10-09	2020-12-16
22	789	2021-01-14	2021-04-25
6	112	2021-02-26	2020-08-14
19	959	2020-11-05	2020-07-14
21	168	2021-02-26	2020-10-14
16	820	2021-02-24	2021-03-19
8	193	2020-07-06	2020-06-21
37	721	2020-10-15	2020-06-14
13	118	2021-02-11	2020-12-31
15	885	2020-12-16	2021-05-03
26	873	2020-12-12	2020-06-20
35	717	2020-10-30	2020-08-29
37	299	2020-07-27	2020-10-18
36	83	2020-08-26	2020-10-15
16	49	2021-02-28	2020-06-10
10	232	2020-09-30	2021-06-06
23	807	2020-08-15	2021-05-16
26	83	2021-04-04	2021-06-07
28	305	2021-02-18	2020-10-18
32	569	2020-12-04	2020-09-22
17	603	2021-02-05	2020-09-18
9	4	2021-04-11	2021-03-18
32	631	2021-06-04	2021-02-22
3	884	2020-11-09	2021-03-12
37	198	2020-12-27	2020-08-14
9	223	2020-11-10	2021-05-25
1	889	2021-05-11	2020-10-08
21	658	2020-12-21	2021-04-28
13	456	2020-06-17	2020-10-18
23	117	2020-12-17	2021-03-17
35	564	2020-12-16	2021-03-10
15	920	2020-09-30	2020-10-26
12	48	2020-07-16	2020-08-12
26	279	2020-07-06	2020-12-03
15	656	2021-01-29	2021-04-30
23	3	2020-10-28	2020-07-12
29	384	2020-06-09	2020-08-08
16	732	2021-04-22	2020-08-02
31	487	2021-04-15	2020-09-04
26	557	2021-01-31	2021-02-22
24	224	2021-04-13	2020-11-22
17	503	2020-10-02	2020-09-12
13	313	2020-08-02	2020-06-25
37	200	2020-10-17	2020-08-02
25	141	2021-03-17	2021-02-09
33	27	2021-04-26	2021-05-12
22	729	2020-08-26	2021-01-15
20	157	2021-05-14	2020-07-19
5	304	2020-09-21	2020-08-04
29	846	2021-03-05	2020-06-19
14	107	2021-04-07	2021-06-02
37	533	2020-12-10	2021-03-22
23	255	2020-08-28	2020-08-14
28	1000	2021-05-15	2021-03-14
5	934	2021-02-25	2021-06-02
15	988	2021-05-05	2020-08-12
13	670	2021-02-05	2021-01-09
13	267	2021-04-30	2020-07-11
2	274	2021-02-03	2021-06-04
24	662	2020-06-17	2021-03-15
32	732	2020-08-02	2021-05-01
34	210	2021-04-30	2020-07-02
13	633	2020-11-15	2021-05-04
29	708	2021-05-10	2021-01-26
22	856	2020-12-05	2020-07-24
33	864	2021-02-13	2020-10-31
10	778	2020-08-08	2021-03-12
22	66	2021-05-06	2020-10-24
23	288	2020-10-08	2020-07-03
2	538	2020-10-16	2020-11-19
35	30	2021-03-11	2021-03-02
14	27	2021-02-12	2021-02-25
9	107	2020-07-27	2020-08-19
17	802	2021-04-28	2021-01-17
12	575	2021-06-05	2021-03-26
33	979	2020-07-26	2020-06-11
37	419	2020-09-15	2021-05-06
1	227	2021-01-21	2020-10-16
16	226	2021-05-14	2020-09-06
33	998	2020-10-28	2020-10-28
31	966	2020-07-10	2020-11-19
27	578	2020-11-01	2020-06-28
3	750	2020-10-21	2020-08-17
21	541	2020-07-09	2020-12-08
14	393	2021-04-23	2021-02-20
14	560	2021-04-22	2020-10-20
23	36	2020-10-23	2020-08-09
5	99	2020-11-13	2021-04-28
24	968	2021-01-27	2021-02-04
18	426	2020-12-15	2021-02-10
23	9	2020-10-31	2020-12-16
2	926	2021-04-25	2020-08-22
20	161	2021-01-08	2021-01-17
23	937	2020-08-08	2020-10-31
15	860	2020-12-29	2021-01-14
8	272	2021-04-28	2021-04-07
13	251	2020-10-25	2020-12-18
9	310	2020-11-02	2021-01-25
32	729	2020-11-30	2021-01-05
28	893	2021-02-23	2021-05-31
34	856	2020-11-07	2021-03-01
23	699	2020-12-20	2020-09-18
37	379	2020-06-14	2021-03-25
34	633	2020-12-31	2020-06-22
18	143	2020-08-25	2021-01-02
35	173	2020-08-12	2021-02-17
6	189	2021-01-17	2021-02-18
9	700	2021-04-17	2020-10-03
22	346	2020-11-26	2020-11-28
27	755	2020-06-23	2020-12-29
1	950	2021-04-06	2020-09-05
4	533	2021-01-29	2021-05-28
28	320	2020-08-12	2021-05-08
30	837	2020-11-16	2020-06-26
21	177	2020-07-04	2020-09-30
7	837	2020-06-16	2020-06-26
1	690	2020-09-29	2021-01-04
26	523	2020-07-06	2020-06-29
36	78	2020-09-24	2020-08-16
11	400	2021-03-02	2020-08-12
6	884	2021-05-30	2020-07-29
28	553	2020-12-13	2020-11-08
29	979	2020-09-18	2020-06-17
17	527	2020-08-07	2021-01-23
10	126	2021-01-07	2020-10-08
12	374	2020-10-31	2021-04-25
7	898	2021-03-06	2020-06-10
26	868	2020-08-01	2021-05-13
5	463	2021-03-02	2020-11-10
29	104	2020-07-23	2020-07-14
34	262	2021-04-06	2021-03-13
28	935	2020-10-23	2020-09-25
26	816	2021-02-04	2021-05-03
28	387	2020-07-26	2021-04-28
22	325	2021-03-29	2020-10-06
8	291	2020-12-03	2020-11-08
20	877	2020-12-17	2020-07-12
1	424	2021-06-04	2020-06-19
6	816	2020-06-25	2020-07-05
12	385	2021-05-04	2020-10-02
7	827	2021-01-17	2020-07-14
32	960	2021-05-08	2020-12-11
6	779	2020-06-25	2020-08-16
37	935	2020-11-30	2020-11-07
13	134	2021-02-08	2021-01-08
32	859	2020-06-22	2020-12-25
12	667	2020-09-14	2020-08-22
3	562	2021-05-30	2021-01-28
11	43	2021-05-16	2020-09-26
33	835	2020-09-02	2021-03-10
10	685	2020-10-21	2020-09-12
19	367	2020-08-05	2020-10-09
12	454	2020-10-07	2021-02-17
29	597	2021-01-27	2021-02-21
30	763	2020-12-05	2020-08-24
16	425	2020-11-28	2021-01-25
30	375	2021-02-26	2020-12-21
14	14	2020-12-22	2021-01-30
31	628	2021-05-21	2020-07-13
32	649	2021-05-31	2021-04-28
34	944	2020-09-18	2021-02-06
26	79	2020-09-29	2020-07-25
13	928	2020-06-12	2020-08-19
3	978	2020-12-14	2021-05-20
28	758	2021-04-04	2020-06-27
37	678	2021-05-11	2021-03-16
34	760	2020-06-23	2021-01-19
9	581	2020-12-16	2020-09-15
24	169	2020-07-22	2021-03-08
24	52	2020-09-18	2020-10-18
25	444	2021-01-27	2020-11-19
9	719	2021-01-19	2021-02-19
27	239	2021-03-20	2020-10-06
26	103	2021-05-09	2021-02-17
29	245	2021-03-06	2020-08-27
26	165	2021-04-06	2020-10-07
28	104	2021-02-12	2021-04-12
10	399	2021-03-05	2020-11-19
15	916	2020-09-11	2021-05-29
6	8	2020-12-22	2020-09-11
10	463	2020-10-17	2021-05-01
37	558	2021-06-07	2020-11-23
16	85	2020-10-07	2020-12-31
34	470	2020-09-23	2021-03-31
9	720	2020-12-18	2020-12-08
36	590	2020-11-09	2020-11-20
3	85	2020-08-10	2021-05-26
7	627	2020-09-17	2020-11-30
26	493	2021-05-11	2020-11-16
24	39	2020-12-15	2020-11-18
28	533	2021-01-03	2021-05-28
15	922	2020-10-19	2021-05-12
28	682	2020-10-13	2021-01-31
8	431	2021-05-29	2020-07-08
3	991	2020-10-08	2020-09-03
31	67	2021-01-17	2020-12-15
16	899	2020-07-06	2020-07-15
35	765	2020-06-22	2020-09-18
26	608	2021-04-18	2020-12-06
11	719	2020-06-14	2020-10-24
31	379	2021-01-15	2020-09-07
31	567	2020-09-15	2020-12-23
37	363	2021-02-09	2021-05-05
2	490	2021-01-10	2020-11-16
8	682	2021-05-09	2020-07-14
21	85	2020-07-27	2021-04-18
27	819	2020-12-19	2020-08-04
30	190	2021-04-01	2020-07-21
25	382	2021-01-11	2021-03-05
33	317	2021-06-02	2020-12-15
13	833	2020-08-02	2020-08-12
27	892	2020-09-22	2021-01-05
22	198	2021-02-06	2020-08-24
16	124	2020-09-03	2021-01-22
23	336	2021-04-17	2020-08-19
3	190	2021-02-19	2021-03-14
8	190	2020-11-26	2020-09-25
29	169	2020-09-07	2021-04-16
12	206	2021-01-07	2021-05-29
12	664	2020-08-10	2020-11-19
10	345	2020-09-03	2021-02-18
36	808	2020-12-23	2021-01-25
9	155	2020-09-13	2021-03-28
36	140	2020-09-22	2021-03-21
21	438	2020-08-19	2020-08-06
2	888	2020-12-06	2020-06-13
4	683	2021-01-15	2021-05-31
15	573	2021-04-18	2020-08-15
16	956	2020-09-20	2021-05-11
31	391	2020-08-11	2020-11-16
28	458	2021-02-21	2021-04-20
8	978	2020-08-02	2021-01-01
5	962	2020-06-23	2020-07-01
20	558	2020-12-07	2020-08-24
16	498	2021-03-14	2020-09-25
8	171	2021-05-18	2021-01-28
1	504	2020-10-12	2020-06-12
25	430	2020-12-14	2020-11-08
4	302	2020-10-09	2021-04-12
28	304	2021-03-16	2021-01-12
29	235	2021-04-05	2021-02-03
10	337	2020-09-16	2021-02-06
24	494	2020-12-13	2021-05-25
33	441	2020-06-20	2020-07-03
17	504	2020-07-14	2021-01-21
16	828	2020-12-05	2021-02-07
28	420	2020-09-28	2020-12-14
31	163	2020-06-29	2020-08-25
37	987	2020-09-03	2020-11-08
30	983	2020-11-08	2020-06-25
35	729	2020-06-28	2020-09-09
26	280	2021-02-10	2021-03-25
26	485	2020-12-25	2020-08-06
26	479	2021-02-08	2021-01-24
7	450	2020-06-26	2020-12-29
31	26	2021-01-25	2020-07-26
29	398	2021-03-08	2021-05-24
9	139	2021-03-16	2021-02-26
32	428	2020-12-25	2020-07-07
33	121	2020-07-24	2020-07-23
29	12	2021-05-01	2020-07-03
36	215	2021-02-01	2021-01-22
28	706	2020-08-13	2021-05-23
31	336	2020-07-03	2020-09-19
9	233	2021-01-17	2020-11-23
37	61	2020-06-21	2021-05-29
16	620	2020-12-17	2021-03-11
18	830	2020-08-01	2021-02-12
18	107	2020-08-07	2021-02-26
25	303	2020-12-22	2021-01-28
25	680	2020-07-05	2021-05-06
29	293	2021-04-04	2021-04-21
22	827	2020-09-13	2021-05-14
6	943	2021-05-12	2020-10-24
21	334	2021-04-23	2020-09-12
29	928	2020-11-06	2021-02-14
19	146	2021-03-29	2020-11-03
20	426	2021-03-07	2021-05-25
3	595	2021-05-19	2020-09-28
26	259	2021-02-28	2020-09-01
35	210	2020-11-25	2021-03-10
27	578	2021-01-30	2021-03-16
15	182	2020-10-06	2020-08-10
26	814	2021-01-05	2020-12-24
11	82	2021-03-04	2020-12-01
15	613	2020-11-26	2020-10-24
15	240	2020-12-26	2020-09-06
25	896	2020-10-22	2020-09-23
28	552	2020-07-24	2020-07-04
14	212	2021-05-20	2020-10-21
6	434	2020-08-01	2020-06-13
24	745	2021-02-16	2021-02-01
18	91	2020-11-11	2020-11-13
7	644	2021-02-23	2020-07-04
9	225	2021-04-04	2021-01-09
35	210	2020-07-15	2021-03-02
10	549	2020-07-03	2020-06-28
33	452	2020-06-11	2020-07-21
20	112	2020-07-06	2021-05-06
27	904	2020-07-25	2021-01-16
27	772	2021-02-14	2020-12-17
28	450	2021-01-02	2020-12-18
10	435	2020-10-13	2021-03-13
2	902	2021-03-28	2021-05-01
2	901	2021-04-21	2021-01-26
31	933	2021-01-01	2021-04-30
25	11	2021-06-06	2020-09-01
5	397	2021-01-14	2021-02-17
18	720	2021-06-03	2020-09-15
17	918	2020-08-07	2021-06-04
21	519	2020-09-17	2021-02-03
36	965	2021-03-19	2020-11-25
30	902	2020-10-03	2021-05-29
4	749	2020-09-09	2020-11-02
7	983	2020-12-26	2020-10-27
33	956	2021-02-08	2021-01-30
13	99	2020-11-08	2020-10-28
30	338	2020-08-31	2021-06-07
29	648	2021-03-20	2021-03-23
7	32	2021-03-24	2020-11-17
26	463	2020-12-07	2020-11-03
29	156	2020-10-14	2021-01-03
16	298	2021-02-02	2020-06-11
26	387	2020-06-17	2020-09-15
8	769	2020-12-01	2020-07-10
26	745	2020-12-18	2020-06-09
34	990	2021-04-20	2021-03-26
34	853	2020-12-29	2020-07-06
9	107	2021-01-26	2020-09-19
21	103	2020-11-29	2020-06-11
28	545	2020-10-20	2020-06-16
4	116	2021-03-31	2021-05-25
15	86	2020-10-29	2020-07-04
35	600	2020-09-12	2021-04-03
34	177	2020-07-03	2020-12-01
6	563	2021-01-26	2021-03-30
6	330	2021-01-23	2020-11-17
16	247	2021-04-14	2021-02-20
1	510	2020-06-20	2020-07-08
11	883	2021-03-30	2021-01-14
7	802	2020-12-06	2021-02-10
11	756	2020-12-19	2021-04-09
23	953	2021-05-01	2020-09-18
7	764	2021-04-11	2020-09-15
33	923	2020-08-20	2020-09-12
9	541	2021-06-06	2021-02-25
14	13	2020-08-15	2020-12-15
17	265	2020-11-16	2020-10-24
31	588	2020-07-27	2021-04-26
4	562	2020-10-23	2020-11-04
9	734	2020-10-17	2020-08-26
37	175	2020-10-05	2020-11-15
9	702	2021-05-14	2020-10-13
27	61	2021-01-29	2020-08-18
7	165	2020-09-16	2021-03-03
8	748	2020-10-25	2021-05-28
5	622	2020-09-09	2020-11-06
2	161	2020-12-03	2021-02-16
19	828	2021-03-25	2020-12-06
24	151	2021-01-20	2021-02-21
10	484	2021-04-10	2020-11-27
27	550	2020-10-12	2021-02-19
28	561	2020-11-02	2021-05-08
8	562	2020-12-02	2020-12-26
21	924	2020-06-18	2021-05-01
9	480	2020-11-06	2020-08-21
15	478	2020-10-16	2021-02-17
5	435	2020-07-20	2021-05-21
35	357	2020-12-18	2021-01-27
4	116	2021-02-23	2020-12-24
9	135	2020-11-20	2021-02-23
22	102	2020-12-04	2021-03-14
11	819	2020-10-23	2020-11-30
3	900	2021-01-20	2021-01-31
2	889	2021-03-13	2021-01-29
13	829	2020-10-04	2020-10-29
28	378	2021-04-09	2021-03-11
7	596	2021-01-08	2021-06-01
24	325	2020-07-17	2020-09-18
25	33	2020-11-22	2020-10-07
12	241	2021-04-27	2020-08-14
9	526	2020-09-28	2020-07-03
16	482	2020-06-28	2021-05-31
18	552	2021-03-17	2020-07-20
8	597	2020-06-13	2021-02-15
12	853	2020-07-12	2021-04-25
9	217	2020-12-01	2021-05-20
27	156	2020-08-07	2021-01-27
28	710	2021-02-11	2021-04-22
30	870	2020-12-22	2020-10-29
28	133	2021-06-03	2020-11-24
36	700	2021-03-05	2020-10-19
34	736	2021-01-12	2020-10-04
5	835	2020-10-08	2020-07-02
3	779	2020-09-06	2020-12-30
26	461	2021-03-19	2020-10-15
18	399	2021-01-03	2021-03-08
30	239	2020-11-21	2021-01-20
24	493	2020-06-24	2020-08-11
6	306	2021-04-05	2020-09-09
16	328	2020-11-30	2021-03-10
24	899	2020-10-27	2021-03-31
20	374	2021-02-06	2020-08-18
2	739	2021-02-24	2020-12-22
23	148	2021-04-23	2020-11-22
32	328	2020-07-24	2020-12-17
29	684	2021-02-06	2020-07-25
16	68	2021-05-07	2021-01-22
15	122	2020-09-01	2020-09-25
32	120	2020-09-29	2021-01-31
19	862	2021-01-04	2020-09-18
3	653	2020-10-02	2021-04-08
2	930	2021-02-25	2021-05-20
12	513	2020-11-18	2021-03-19
13	637	2020-12-05	2021-03-07
15	335	2021-02-21	2020-08-10
11	8	2021-01-11	2020-09-02
22	424	2020-08-22	2020-07-13
8	582	2021-05-27	2021-01-31
23	540	2021-01-17	2020-09-18
36	903	2020-07-30	2021-02-21
37	405	2020-11-04	2021-02-28
15	416	2020-08-01	2020-07-20
23	953	2021-04-12	2021-01-16
31	547	2020-10-17	2021-03-14
16	522	2021-05-06	2021-03-16
28	549	2020-06-18	2021-02-16
29	126	2021-01-02	2020-06-20
1	166	2020-07-18	2021-01-22
12	828	2021-05-13	2020-07-16
2	283	2020-08-10	2020-06-27
12	679	2021-01-06	2020-07-13
24	461	2020-12-01	2020-07-12
20	818	2021-04-09	2020-06-14
34	269	2020-06-14	2020-11-11
12	836	2020-08-24	2021-01-17
29	662	2020-09-20	2021-02-18
28	765	2020-06-23	2020-12-28
8	794	2020-06-23	2020-06-28
1	501	2021-04-16	2020-12-05
22	867	2020-07-14	2021-02-01
13	435	2021-02-09	2021-06-06
2	541	2021-04-18	2021-05-24
9	556	2021-04-10	2020-11-21
11	222	2020-07-16	2020-07-30
21	353	2021-01-29	2021-04-23
8	8	2020-12-27	2021-01-05
18	377	2020-07-24	2020-12-03
16	768	2020-06-25	2021-02-14
5	795	2020-12-17	2020-11-01
2	989	2021-03-08	2021-03-25
22	746	2020-10-27	2020-09-24
29	359	2021-01-22	2020-11-11
21	341	2021-05-29	2020-12-23
20	858	2021-05-12	2021-02-22
24	224	2020-10-27	2020-08-14
22	691	2020-07-05	2020-07-01
18	301	2020-08-24	2020-12-09
22	398	2021-05-02	2021-01-13
8	141	2020-08-10	2021-04-12
25	786	2021-03-27	2021-01-03
36	235	2021-06-04	2021-04-10
29	964	2020-12-19	2020-06-28
34	512	2020-07-01	2020-09-06
32	414	2020-11-06	2020-07-04
23	938	2020-12-15	2021-02-28
31	815	2021-03-08	2021-03-03
13	172	2020-12-28	2021-01-30
35	404	2020-09-25	2021-05-22
5	127	2020-11-26	2021-01-07
17	29	2020-11-14	2020-08-10
33	122	2020-08-13	2020-09-25
20	48	2020-11-08	2020-08-31
28	44	2020-07-02	2021-02-20
24	250	2020-11-29	2020-10-31
15	298	2020-09-29	2020-10-26
17	891	2021-01-05	2020-09-07
7	493	2021-03-08	2020-12-15
37	815	2021-04-06	2020-09-21
27	22	2021-01-19	2020-12-25
16	976	2020-08-13	2020-07-06
11	275	2021-06-05	2020-12-11
14	541	2021-05-15	2021-02-17
32	250	2021-04-14	2021-04-17
14	207	2020-06-20	2020-06-19
31	427	2020-08-08	2020-12-24
20	97	2021-01-06	2021-04-23
24	690	2021-01-23	2020-08-02
4	311	2020-09-21	2020-11-01
37	76	2020-09-04	2020-11-30
19	714	2021-05-19	2020-08-20
32	107	2020-12-26	2021-05-10
33	326	2020-08-24	2020-10-24
25	243	2020-08-02	2021-05-28
12	399	2021-02-14	2020-11-02
27	806	2020-10-17	2020-06-15
34	586	2020-11-11	2020-10-30
4	197	2021-02-24	2021-04-16
24	34	2021-02-02	2020-09-07
6	487	2021-01-24	2021-03-16
34	549	2020-12-15	2020-08-15
6	883	2020-11-22	2020-07-17
13	203	2020-11-10	2020-09-17
35	621	2020-08-17	2021-03-26
32	372	2021-04-28	2021-04-22
8	730	2021-03-18	2020-08-04
32	15	2021-01-25	2020-08-23
23	31	2021-04-27	2020-07-07
13	785	2020-07-26	2020-11-24
18	103	2020-12-26	2020-06-19
27	23	2021-06-01	2021-03-05
24	985	2021-01-07	2021-03-26
22	197	2021-03-04	2021-05-11
31	505	2020-10-14	2021-04-04
19	1	2021-05-18	2020-07-12
6	901	2021-02-02	2021-02-08
15	390	2021-01-07	2020-12-21
2	622	2020-06-24	2021-01-17
8	341	2020-10-01	2020-12-03
1	275	2020-06-19	2021-02-23
27	133	2020-11-16	2020-10-18
19	977	2021-03-18	2020-06-22
21	206	2020-08-29	2020-06-23
20	31	2020-12-09	2020-10-20
23	87	2021-05-01	2021-05-15
32	327	2021-01-23	2020-11-03
3	932	2020-08-16	2020-10-02
20	276	2020-10-24	2020-11-21
9	144	2021-06-07	2021-05-04
12	91	2020-10-08	2020-06-30
35	919	2020-07-25	2020-09-29
34	695	2021-01-27	2021-06-03
25	336	2020-12-29	2021-05-30
28	333	2021-05-30	2021-05-20
2	703	2020-11-10	2021-02-06
22	936	2020-09-30	2020-12-27
7	830	2020-08-24	2020-11-10
3	566	2020-08-25	2021-04-24
15	595	2021-02-12	2020-07-12
30	363	2020-08-31	2020-07-29
21	958	2021-04-07	2021-03-03
25	974	2021-05-07	2020-09-03
37	839	2020-11-06	2020-08-21
14	316	2020-08-14	2021-03-21
30	257	2021-04-26	2020-10-01
13	442	2020-12-21	2020-07-04
4	374	2020-10-17	2021-04-30
12	588	2020-06-26	2021-02-01
16	172	2021-03-19	2021-01-28
10	219	2020-09-29	2020-10-20
8	69	2021-01-15	2021-01-14
12	633	2021-03-29	2020-09-03
24	768	2021-01-02	2020-11-12
17	246	2021-01-24	2021-01-10
13	260	2020-06-10	2020-07-01
30	967	2021-03-20	2021-05-21
2	251	2021-05-23	2021-01-18
21	123	2020-10-22	2020-07-20
21	647	2021-05-18	2020-07-31
35	842	2020-07-31	2020-07-29
3	906	2021-02-23	2020-08-29
27	635	2021-05-09	2020-11-06
34	747	2020-08-18	2020-09-22
20	598	2021-01-06	2021-05-12
33	225	2020-11-22	2020-09-19
13	363	2020-10-08	2021-06-08
15	776	2021-01-21	2020-10-05
6	403	2020-11-06	2021-02-28
24	832	2020-12-06	2020-08-23
35	749	2021-05-27	2020-06-19
7	242	2020-07-25	2021-04-24
35	391	2021-04-17	2021-01-14
22	415	2020-11-06	2021-03-16
10	746	2020-12-23	2021-01-12
25	817	2020-07-17	2020-12-12
8	788	2020-12-13	2021-03-27
19	627	2021-04-23	2021-05-08
5	266	2021-01-09	2021-02-03
35	835	2020-12-29	2021-03-22
34	194	2020-09-16	2021-02-02
3	548	2021-01-18	2021-04-17
27	839	2020-11-24	2020-09-05
27	639	2020-08-28	2020-12-31
7	937	2020-11-29	2021-03-02
34	876	2020-12-24	2021-02-19
7	165	2021-05-16	2020-09-02
22	919	2021-06-05	2020-09-18
32	17	2020-06-27	2020-10-01
32	558	2020-08-21	2020-08-17
29	690	2020-10-15	2020-10-08
11	238	2021-02-26	2021-02-23
13	211	2020-07-30	2021-01-03
16	614	2021-05-10	2021-01-10
23	148	2021-03-13	2020-09-15
33	360	2020-12-15	2021-04-15
26	774	2021-05-03	2021-04-27
24	525	2021-01-09	2020-11-06
31	518	2020-10-20	2021-01-13
22	534	2020-12-22	2020-09-30
14	933	2021-04-22	2021-05-02
19	159	2020-10-03	2020-06-22
2	449	2021-05-17	2020-12-31
3	419	2020-07-24	2021-04-19
13	135	2020-08-02	2020-09-01
21	893	2020-11-07	2020-06-22
18	894	2021-01-14	2021-04-03
32	198	2020-11-30	2020-08-02
1	251	2021-03-29	2020-12-16
12	564	2020-07-04	2020-06-17
34	80	2021-04-06	2020-06-22
37	499	2020-12-15	2021-03-24
29	786	2020-06-28	2021-06-07
24	926	2020-08-02	2020-06-28
20	201	2020-09-15	2020-07-13
14	771	2021-01-13	2020-11-07
16	140	2020-07-23	2020-11-20
37	135	2020-08-31	2020-07-01
12	133	2020-10-27	2020-06-16
18	543	2020-11-20	2021-05-14
35	848	2020-07-30	2021-01-02
1	213	2021-03-09	2020-12-10
4	883	2021-04-25	2021-02-03
15	951	2021-01-12	2020-09-01
14	141	2021-06-06	2021-04-24
7	747	2021-05-15	2020-10-09
24	542	2020-12-19	2020-11-04
26	500	2020-11-29	2020-08-28
25	193	2021-04-30	2021-06-01
16	357	2020-07-17	2020-08-06
19	963	2020-06-28	2021-04-12
34	470	2021-03-14	2020-06-23
20	25	2021-02-04	2020-12-25
35	860	2021-03-11	2020-12-03
17	471	2021-05-12	2020-06-10
8	132	2021-02-20	2020-08-18
2	193	2021-02-25	2021-06-05
23	442	2021-01-16	2021-04-14
11	733	2020-09-07	2020-10-02
20	476	2020-09-12	2020-12-04
27	54	2020-06-18	2021-03-30
20	401	2020-09-29	2020-06-24
19	993	2020-10-27	2021-03-05
6	948	2020-07-17	2020-07-04
5	714	2021-02-17	2020-08-02
28	544	2020-08-16	2020-06-23
34	81	2020-11-17	2021-02-10
15	429	2020-08-31	2021-06-02
5	550	2020-07-30	2020-11-06
3	521	2021-03-31	2020-09-22
8	716	2021-06-07	2020-10-22
37	767	2020-08-08	2020-09-12
13	280	2020-12-27	2020-12-31
10	327	2020-09-27	2020-10-07
29	369	2020-11-18	2021-04-17
27	803	2020-10-09	2020-07-03
10	361	2021-04-09	2021-02-22
23	201	2021-06-05	2021-03-03
35	348	2021-04-25	2020-10-28
29	569	2020-07-26	2020-10-23
2	644	2020-09-22	2021-03-10
36	878	2020-09-16	2021-04-16
24	108	2021-04-21	2020-06-29
31	2	2021-02-20	2021-01-27
9	541	2020-09-26	2020-12-17
3	644	2021-02-28	2020-11-26
1	771	2020-09-06	2021-04-04
24	302	2020-08-08	2020-09-05
15	866	2020-10-17	2020-09-08
22	492	2021-03-21	2021-06-01
32	572	2020-07-14	2020-07-18
12	469	2020-08-17	2021-02-16
35	957	2021-01-19	2020-09-07
13	272	2020-10-01	2020-10-15
24	16	2020-11-21	2021-02-27
21	834	2020-07-22	2020-09-20
34	383	2021-05-12	2021-04-24
28	795	2021-05-04	2021-02-15
13	912	2021-04-07	2020-11-25
6	729	2021-03-04	2020-07-25
33	116	2021-02-10	2020-11-10
8	933	2020-11-03	2021-06-08
13	52	2021-01-01	2021-02-11
11	290	2020-06-26	2020-10-09
10	961	2021-05-20	2020-09-30
36	849	2021-05-27	2020-07-07
35	794	2020-10-19	2021-01-09
12	654	2020-07-28	2021-05-02
8	336	2021-04-04	2021-04-20
28	851	2021-01-16	2020-10-22
33	129	2021-04-01	2020-11-06
5	108	2021-05-17	2021-03-03
8	34	2020-06-21	2021-02-18
27	881	2020-08-26	2021-01-06
15	975	2021-01-19	2021-02-17
15	961	2021-02-16	2020-12-03
30	706	2021-01-10	2020-10-01
32	140	2021-05-08	2021-03-21
10	515	2021-04-08	2021-03-19
9	328	2021-02-17	2021-02-17
21	82	2021-03-01	2021-01-26
23	726	2021-05-29	2021-01-28
23	500	2020-09-24	2020-12-05
12	228	2020-12-16	2020-10-25
28	747	2020-10-18	2020-08-07
22	404	2021-05-13	2020-06-17
17	695	2021-03-18	2020-09-23
13	174	2020-11-25	2020-10-23
33	392	2020-06-26	2020-08-17
19	536	2020-10-10	2021-01-31
11	58	2020-12-13	2021-04-21
15	342	2021-02-09	2020-12-14
25	984	2021-05-25	2021-05-27
20	654	2020-09-18	2020-09-30
18	527	2020-12-03	2020-10-15
27	93	2021-01-12	2020-10-03
23	888	2021-02-06	2020-08-10
\.


--
-- Data for Name: czlowieki; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.czlowieki (czlowieki_id, name, surrname, middle_name, email, date_of_joint) FROM stdin;
2	Janusz	Koriwn	Mekke	2@fajna_biblioteka_2137.pl	2021-06-06
1	Elsinore	Tackes	晧宇	etackes0@baidu.com	1980-10-05
3	Brinna	Alasdair	\N	3@fajna_biblioteka_2137.pl	2021-06-09
4	Rowen	Sydall	\N	4@fajna_biblioteka_2137.pl	2021-06-09
5	Read	Yashunin	龙胜	ryashunin4@psu.edu	2095-07-05
6	Max	Yonnie	\N	6@fajna_biblioteka_2137.pl	2021-06-09
7	Ches	Way	怡香	cway6@alibaba.com	1901-03-14
8	Karlotta	Ivain	\N	8@fajna_biblioteka_2137.pl	2021-06-09
9	Aloisia	Richardsson	俊泽	arichardsson8@studiopress.com	1969-08-23
10	Mada	Durston	\N	10@fajna_biblioteka_2137.pl	2021-06-09
11	Cirillo	Mein	\N	11@fajna_biblioteka_2137.pl	2021-06-09
12	Nikki	Akess	松源	nakessb@mysql.com	2005-09-21
13	Isaiah	Morrant	美莲	imorrantc@ning.com	2031-10-29
14	Julina	Dorricott	远帆	jdorricottd@devhub.com	2029-08-01
15	Lona	Hazelgreave	\N	15@fajna_biblioteka_2137.pl	2021-06-09
16	Annora	Brandenburg	松源	abrandenburgf@cdc.gov	2019-07-18
17	Nicoli	Harnor	\N	17@fajna_biblioteka_2137.pl	2021-06-09
18	Ema	Cripps	\N	18@fajna_biblioteka_2137.pl	2021-06-09
19	Jamison	Kembry	冠泽	jkembryi@purevolume.com	2016-09-20
20	Marylee	Cammomile	\N	20@fajna_biblioteka_2137.pl	2021-06-09
21	Arlee	Marquet	\N	21@fajna_biblioteka_2137.pl	2021-06-09
22	Carny	Bruhn	\N	22@fajna_biblioteka_2137.pl	2021-06-09
23	Codi	McGrudder	尹智	cmcgrudderm@bbb.org	1958-05-02
24	Joel	Hotton	\N	24@fajna_biblioteka_2137.pl	2021-06-09
25	Sheffy	Orgen	\N	25@fajna_biblioteka_2137.pl	2021-06-09
26	Roderic	Draude	羽彤	rdraudep@jugem.jp	1954-08-03
27	Benson	Dungey	\N	27@fajna_biblioteka_2137.pl	2021-06-09
28	Beverley	Yaneev	泽瀚	byaneevr@last.fm	2048-05-25
29	Bernadene	Winspare	慧妍	bwinspares@comsenz.com	2021-11-01
30	Lisabeth	Najera	\N	30@fajna_biblioteka_2137.pl	2021-06-09
31	Hale	Sutherland	\N	31@fajna_biblioteka_2137.pl	2021-06-09
32	Washington	Menault	\N	32@fajna_biblioteka_2137.pl	2021-06-09
33	Alexine	Strachan	彤雨	astrachanw@amazon.de	2072-01-19
34	Barnie	Cowland	雨萌	bcowlandx@rediff.com	1905-09-04
35	Kacie	Scowcraft	银涵	kscowcrafty@npr.org	2096-01-08
36	Roberta	Glidder	\N	36@fajna_biblioteka_2137.pl	2021-06-09
37	Darlene	Knudsen	\N	37@fajna_biblioteka_2137.pl	2021-06-09
38	Heidi	Wayte	\N	38@fajna_biblioteka_2137.pl	2021-06-09
39	Waring	Reah	若瑾	wreah12@cisco.com	2076-02-22
40	Maggee	Hartright	远帆	mhartright13@bravesites.com	2034-12-28
41	Lucy	Skerm	佐仪	lskerm14@fastcompany.com	1914-08-09
42	Abran	McCrackem	\N	42@fajna_biblioteka_2137.pl	2021-06-09
43	Marietta	Devitt	碧萱	mdevitt16@github.com	2048-03-17
44	Taddeusz	Webber	\N	44@fajna_biblioteka_2137.pl	2021-06-09
45	Alley	Gwilym	\N	45@fajna_biblioteka_2137.pl	2021-06-09
46	Dominik	Chadbourne	\N	46@fajna_biblioteka_2137.pl	2021-06-09
47	Haydon	Gourlay	\N	47@fajna_biblioteka_2137.pl	2021-06-09
48	Dehlia	Chesman	\N	48@fajna_biblioteka_2137.pl	2021-06-09
49	Elnore	Bostick	\N	49@fajna_biblioteka_2137.pl	2021-06-09
50	Shurlocke	Shakespear	\N	50@fajna_biblioteka_2137.pl	2021-06-09
51	Dana	Eschelle	美琳	deschelle1e@ifeng.com	2051-07-09
52	Merry	Schaffel	漫妮	mschaffel1f@slate.com	2041-01-07
53	Town	Myers	\N	53@fajna_biblioteka_2137.pl	2021-06-09
54	Consuelo	Parr	\N	54@fajna_biblioteka_2137.pl	2021-06-09
55	Richy	Westwell	宇涵	rwestwell1i@fotki.com	1915-11-23
56	Archibaldo	Hearmon	哲恒	ahearmon1j@1688.com	1958-05-26
57	Barbe	Gotfrey	宸赫	bgotfrey1k@photobucket.com	1965-11-01
58	Babbette	Eltone	\N	58@fajna_biblioteka_2137.pl	2021-06-09
59	Ronny	Rishman	\N	59@fajna_biblioteka_2137.pl	2021-06-09
60	Filberte	Halburton	彤雨	fhalburton1n@slate.com	2023-05-07
61	Wilie	Lamplough	\N	61@fajna_biblioteka_2137.pl	2021-06-09
62	Rip	Drought	婧琪	rdrought1p@flickr.com	1928-04-12
63	Dede	Dublin	梦洁	ddublin1q@lycos.com	2010-07-28
64	Stella	Tremblett	\N	64@fajna_biblioteka_2137.pl	2021-06-09
65	Etty	Dilawey	羽彤	edilawey1s@uiuc.edu	1991-03-19
66	Cybill	Surmeyer	\N	66@fajna_biblioteka_2137.pl	2021-06-09
67	Petunia	Buist	海程	pbuist1u@pbs.org	1930-06-12
68	Thorpe	Degoix	\N	68@fajna_biblioteka_2137.pl	2021-06-09
69	Elinore	Gaiter	\N	69@fajna_biblioteka_2137.pl	2021-06-09
70	Katharine	Blown	笑薇	kblown1x@whitehouse.gov	2099-10-16
71	Henrieta	Grewcock	\N	71@fajna_biblioteka_2137.pl	2021-06-09
72	Raffaello	Withers	\N	72@fajna_biblioteka_2137.pl	2021-06-09
73	Maritsa	Cobbing	\N	73@fajna_biblioteka_2137.pl	2021-06-09
74	Dick	Hearse	\N	74@fajna_biblioteka_2137.pl	2021-06-09
75	Shadow	Lycett	\N	75@fajna_biblioteka_2137.pl	2021-06-09
76	Matthaeus	Toe	\N	76@fajna_biblioteka_2137.pl	2021-06-09
77	Kirk	Sommerville	梓焓	ksommerville24@wikia.com	2009-10-10
78	Bryant	Welberry	\N	78@fajna_biblioteka_2137.pl	2021-06-09
79	Clem	Furlonge	\N	79@fajna_biblioteka_2137.pl	2021-06-09
80	Prent	Corby	\N	80@fajna_biblioteka_2137.pl	2021-06-09
81	Frannie	Stenhouse	\N	81@fajna_biblioteka_2137.pl	2021-06-09
82	Stanly	Clewlowe	\N	82@fajna_biblioteka_2137.pl	2021-06-09
83	Maure	Minithorpe	\N	83@fajna_biblioteka_2137.pl	2021-06-09
84	Lothaire	Tester	\N	84@fajna_biblioteka_2137.pl	2021-06-09
85	Helga	Roussell	清凌	hroussell2c@ed.gov	1924-02-12
86	Marylou	Featherstonehaugh	博裕	mfeatherstonehaugh2d@moonfruit.com	1967-03-15
87	Libbie	Sweed	\N	87@fajna_biblioteka_2137.pl	2021-06-09
88	Judye	Keningley	\N	88@fajna_biblioteka_2137.pl	2021-06-09
89	Mara	Callard	浩成	mcallard2g@pagesperso-orange.fr	2084-12-18
90	Kial	Tassell	\N	90@fajna_biblioteka_2137.pl	2021-06-09
91	Sigismond	Andreu	\N	91@fajna_biblioteka_2137.pl	2021-06-09
92	Corine	Kmiec	军卿	ckmiec2j@godaddy.com	1922-01-20
93	Solomon	Gally	\N	93@fajna_biblioteka_2137.pl	2021-06-09
94	Myer	Walley	\N	94@fajna_biblioteka_2137.pl	2021-06-09
95	Carleen	Lamplough	\N	95@fajna_biblioteka_2137.pl	2021-06-09
96	Welsh	Dowzell	\N	96@fajna_biblioteka_2137.pl	2021-06-09
97	Morena	Benedicto	\N	97@fajna_biblioteka_2137.pl	2021-06-09
98	Olivero	Ambrogini	\N	98@fajna_biblioteka_2137.pl	2021-06-09
99	Vivie	Gallard	唯枫	vgallard2q@networkadvertising.org	2090-03-18
100	Duffie	Thombleson	香茹	dthombleson2r@examiner.com	1954-02-01
101	Wallie	Galland	萧然	wgalland2s@opensource.org	1970-01-22
102	Cirstoforo	Buntine	志宸	cbuntine2t@webnode.com	1991-11-01
103	Linnie	Cowie	\N	103@fajna_biblioteka_2137.pl	2021-06-09
104	Laurence	Goose	浩成	lgoose2v@ning.com	1960-03-11
105	Nataniel	Mullen	思宏	nmullen2w@ebay.co.uk	1984-10-15
106	Byrom	Dikels	雪怡	bdikels2x@artisteer.com	2041-02-26
107	Latrina	Van Der Weedenburg	\N	107@fajna_biblioteka_2137.pl	2021-06-09
108	Arabella	Frango	\N	108@fajna_biblioteka_2137.pl	2021-06-09
109	Clark	Rastrick	\N	109@fajna_biblioteka_2137.pl	2021-06-09
110	Cissy	Itzik	\N	110@fajna_biblioteka_2137.pl	2021-06-09
111	Kellen	Abraham	\N	111@fajna_biblioteka_2137.pl	2021-06-09
112	Frankie	Tunsley	晓晴	ftunsley33@mlb.com	1968-04-05
113	Ainslee	Calvey	\N	113@fajna_biblioteka_2137.pl	2021-06-09
114	Sharl	Caherny	\N	114@fajna_biblioteka_2137.pl	2021-06-09
115	Arabelle	Garber	雅芙	agarber36@microsoft.com	1990-06-05
116	Danya	Whalley	\N	116@fajna_biblioteka_2137.pl	2021-06-09
117	Elfrida	Procter	\N	117@fajna_biblioteka_2137.pl	2021-06-09
118	Duncan	Snawden	\N	118@fajna_biblioteka_2137.pl	2021-06-09
119	Kingsly	Doring	哲恒	kdoring3a@miitbeian.gov.cn	2025-06-14
120	Isidora	Spieck	\N	120@fajna_biblioteka_2137.pl	2021-06-09
121	Tomaso	Padkin	泰霖	tpadkin3c@godaddy.com	2086-06-07
122	Merrill	Moran	\N	122@fajna_biblioteka_2137.pl	2021-06-09
123	Winny	Roscher	思翰	wroscher3e@deviantart.com	2062-10-26
124	Marguerite	Guarin	\N	124@fajna_biblioteka_2137.pl	2021-06-09
125	Berna	Scorrer	\N	125@fajna_biblioteka_2137.pl	2021-06-09
126	Aileen	Degenhardt	璟雯	adegenhardt3h@cdc.gov	1990-09-05
127	Elga	Flucker	婧琪	eflucker3i@state.gov	2087-02-23
128	Kelcie	Woolfall	\N	128@fajna_biblioteka_2137.pl	2021-06-09
129	Leone	Dyke	俞凯	ldyke3k@soundcloud.com	1975-08-09
130	Norton	Symington	宸瑜	nsymington3l@google.co.uk	2002-12-01
131	Rois	Danbi	\N	131@fajna_biblioteka_2137.pl	2021-06-09
132	Maynard	Dainter	\N	132@fajna_biblioteka_2137.pl	2021-06-09
133	Aurore	O'Lennachain	银涵	aolennachain3o@slashdot.org	2011-05-28
134	Arnuad	Gammon	\N	134@fajna_biblioteka_2137.pl	2021-06-09
135	Goldia	Shearmer	\N	135@fajna_biblioteka_2137.pl	2021-06-09
136	Claire	Gosart	银含	cgosart3r@dyndns.org	1971-03-12
137	Conway	Zecchii	\N	137@fajna_biblioteka_2137.pl	2021-06-09
138	Chadwick	Munslow	\N	138@fajna_biblioteka_2137.pl	2021-06-09
139	Charin	Heeps	剑波	cheeps3u@theglobeandmail.com	2029-09-02
140	Doll	Bleasdille	\N	140@fajna_biblioteka_2137.pl	2021-06-09
141	Brit	Legate	凰羽	blegate3w@barnesandnoble.com	2097-10-30
142	Cindelyn	Pitone	\N	142@fajna_biblioteka_2137.pl	2021-06-09
143	Germana	Kleine	宸瑜	gkleine3y@nydailynews.com	1999-05-12
144	Sarajane	Persence	\N	144@fajna_biblioteka_2137.pl	2021-06-09
145	Yvette	Fassam	欣妍	yfassam40@google.com.au	2066-05-16
146	Virgina	Bricksey	\N	146@fajna_biblioteka_2137.pl	2021-06-09
147	Betta	Benzing	雅静	bbenzing42@google.co.jp	2095-02-03
148	Sigismondo	Osgodby	\N	148@fajna_biblioteka_2137.pl	2021-06-09
149	Jeniece	Marzelli	\N	149@fajna_biblioteka_2137.pl	2021-06-09
150	Lorelle	Mccaull	\N	150@fajna_biblioteka_2137.pl	2021-06-09
151	Jamima	Low	辰华	jlow46@e-recht24.de	1985-05-06
152	Shepperd	Rupp	美琳	srupp47@jimdo.com	2099-11-13
153	Luca	Kunzler	\N	153@fajna_biblioteka_2137.pl	2021-06-09
154	Mab	Ropars	浩霖	mropars49@pen.io	1970-03-20
155	Serene	Copnell	莉姿	scopnell4a@washingtonpost.com	1991-04-17
156	Jesus	Richemond	\N	156@fajna_biblioteka_2137.pl	2021-06-09
157	Eran	Rudall	\N	157@fajna_biblioteka_2137.pl	2021-06-09
158	Phillie	Hunsworth	\N	158@fajna_biblioteka_2137.pl	2021-06-09
159	Rowan	Klaiser	博豪	rklaiser4e@unesco.org	2047-04-18
160	Pete	Cranfield	\N	160@fajna_biblioteka_2137.pl	2021-06-09
161	Ruth	Blazynski	\N	161@fajna_biblioteka_2137.pl	2021-06-09
162	Rossy	Stripp	冠泽	rstripp4h@usda.gov	2082-07-29
163	Candie	Ilchuk	\N	163@fajna_biblioteka_2137.pl	2021-06-09
164	Brandyn	Abad	雅静	babad4j@dion.ne.jp	1979-11-16
165	Bowie	Chable	\N	165@fajna_biblioteka_2137.pl	2021-06-09
166	Druci	Ansty	\N	166@fajna_biblioteka_2137.pl	2021-06-09
167	Darya	Peckett	\N	167@fajna_biblioteka_2137.pl	2021-06-09
168	Betta	Branchett	\N	168@fajna_biblioteka_2137.pl	2021-06-09
169	Mohandis	Aspole	可馨	maspole4o@friendfeed.com	1976-01-07
170	Nesta	Maiklem	\N	170@fajna_biblioteka_2137.pl	2021-06-09
171	Dyann	Middleweek	\N	171@fajna_biblioteka_2137.pl	2021-06-09
172	Ula	Spinage	宇涵	uspinage4r@geocities.jp	1923-12-04
173	Tedie	Overshott	\N	173@fajna_biblioteka_2137.pl	2021-06-09
174	Wynnie	Spoole	雨婷	wspoole4t@pbs.org	2061-01-29
175	Hedwig	Murrum	\N	175@fajna_biblioteka_2137.pl	2021-06-09
176	Hube	Fluck	\N	176@fajna_biblioteka_2137.pl	2021-06-09
177	Harald	Orr	远帆	horr4w@php.net	1950-01-16
178	Starlene	Wollard	\N	178@fajna_biblioteka_2137.pl	2021-06-09
179	Aeriel	Gormley	轩硕	agormley4y@angelfire.com	1928-11-25
180	Consuelo	Toma	\N	180@fajna_biblioteka_2137.pl	2021-06-09
181	Drugi	Betje	雨萌	dbetje50@google.com.hk	2080-08-12
182	Antone	Tomaini	\N	182@fajna_biblioteka_2137.pl	2021-06-09
183	Chantal	Gercke	墨含	cgercke52@cdbaby.com	2004-03-14
184	David	Issatt	碧萱	dissatt53@google.it	1992-11-19
185	Dore	Pressdee	月婵	dpressdee54@cisco.com	2045-02-19
186	Regine	Southon	\N	186@fajna_biblioteka_2137.pl	2021-06-09
187	Melody	Ramme	\N	187@fajna_biblioteka_2137.pl	2021-06-09
188	Luther	Dally	\N	188@fajna_biblioteka_2137.pl	2021-06-09
189	Dot	Colwill	\N	189@fajna_biblioteka_2137.pl	2021-06-09
190	Dennie	Ikin	\N	190@fajna_biblioteka_2137.pl	2021-06-09
191	Corbie	Paxton	\N	191@fajna_biblioteka_2137.pl	2021-06-09
192	Emogene	Granville	明美	egranville5b@globo.com	1995-10-17
193	Basil	Klageman	\N	193@fajna_biblioteka_2137.pl	2021-06-09
194	Marje	McGuinness	正梅	mmcguinness5d@vistaprint.com	1946-04-30
195	Shurwood	Deeley	\N	195@fajna_biblioteka_2137.pl	2021-06-09
196	Roxi	Doudney	冠泽	rdoudney5f@nbcnews.com	1982-03-27
197	Vina	Jencken	展博	vjencken5g@arstechnica.com	1918-11-23
198	Delbert	Gilliatt	\N	198@fajna_biblioteka_2137.pl	2021-06-09
199	Korrie	Johl	\N	199@fajna_biblioteka_2137.pl	2021-06-09
200	Cornelle	Aveline	琪煜	caveline5j@prweb.com	1927-10-07
201	Preston	Minelli	云哲	pminelli5k@deviantart.com	2052-12-15
202	Whittaker	Awty	\N	202@fajna_biblioteka_2137.pl	2021-06-09
203	Martita	Snedden	\N	203@fajna_biblioteka_2137.pl	2021-06-09
204	Godfree	Olenikov	\N	204@fajna_biblioteka_2137.pl	2021-06-09
205	Ilene	Sisneros	\N	205@fajna_biblioteka_2137.pl	2021-06-09
206	Jessi	Brabyn	\N	206@fajna_biblioteka_2137.pl	2021-06-09
207	Anitra	Bello	\N	207@fajna_biblioteka_2137.pl	2021-06-09
208	Faye	Janjic	娅楠	fjanjic5r@google.ru	2037-11-20
209	Talya	Dils	正梅	tdils5s@goo.gl	2062-03-21
210	Kelly	Corey	\N	210@fajna_biblioteka_2137.pl	2021-06-09
211	Glynn	Widmore	海程	gwidmore5u@ucsd.edu	2028-12-20
212	Aloise	Wareham	羽彤	awareham5v@facebook.com	2004-10-12
213	Winni	Coll	博豪	wcoll5w@nationalgeographic.com	1968-11-05
214	Rocky	Eringey	远帆	reringey5x@aol.com	1957-10-25
215	Dmitri	Dietz	\N	215@fajna_biblioteka_2137.pl	2021-06-09
216	Rancell	Gasnell	龙胜	rgasnell5z@jigsy.com	2026-05-24
217	Kikelia	Crayker	\N	217@fajna_biblioteka_2137.pl	2021-06-09
218	Alan	Lovatt	思宇	alovatt61@home.pl	1967-01-11
219	Sari	Brind	\N	219@fajna_biblioteka_2137.pl	2021-06-09
220	Paige	Marrian	依娜	pmarrian63@g.co	1940-12-06
221	Serge	Pawelski	\N	221@fajna_biblioteka_2137.pl	2021-06-09
222	Rickey	Bodocs	\N	222@fajna_biblioteka_2137.pl	2021-06-09
223	Luciano	Felgate	\N	223@fajna_biblioteka_2137.pl	2021-06-09
224	Herminia	Parris	\N	224@fajna_biblioteka_2137.pl	2021-06-09
225	Myranda	Janowski	\N	225@fajna_biblioteka_2137.pl	2021-06-09
226	Kelley	Brosetti	婧琪	kbrosetti69@bizjournals.com	2084-08-28
227	Kelcie	Orris	\N	227@fajna_biblioteka_2137.pl	2021-06-09
228	Erick	Chartre	怡香	echartre6b@examiner.com	2008-01-15
229	Vania	Finicj	博裕	vfinicj6c@acquirethisname.com	1962-10-12
230	Louise	Clearie	\N	230@fajna_biblioteka_2137.pl	2021-06-09
231	Teirtza	Fealty	\N	231@fajna_biblioteka_2137.pl	2021-06-09
232	Hana	Branthwaite	\N	232@fajna_biblioteka_2137.pl	2021-06-09
233	Mellie	Danielut	远帆	mdanielut6g@mtv.com	2032-05-08
234	Derrik	Plaschke	尚贤	dplaschke6h@ebay.com	1931-02-25
235	Lev	Viegas	\N	235@fajna_biblioteka_2137.pl	2021-06-09
236	Francoise	Jann	\N	236@fajna_biblioteka_2137.pl	2021-06-09
237	Jeniffer	Bagnall	宸赫	jbagnall6k@craigslist.org	1922-11-07
238	Elie	Uren	雪丽	euren6l@barnesandnoble.com	1991-05-26
239	Sadella	Ghelerdini	\N	239@fajna_biblioteka_2137.pl	2021-06-09
240	Suzie	Adenet	烨伟	sadenet6n@utexas.edu	1956-05-11
241	Jacqui	Eaglen	远帆	jeaglen6o@sphinn.com	1968-04-25
242	Giffer	Galier	\N	242@fajna_biblioteka_2137.pl	2021-06-09
243	Alphonso	Limpenny	军卿	alimpenny6q@biglobe.ne.jp	1968-01-13
244	Tobin	Surgood	玺越	tsurgood6r@engadget.com	1944-10-13
245	Nolana	Struis	\N	245@fajna_biblioteka_2137.pl	2021-06-09
246	Killie	Bellison	慧妍	kbellison6t@hp.com	1913-06-16
247	Jodie	Gotfrey	昕磊	jgotfrey6u@dot.gov	2095-08-16
248	Ly	Deaves	展博	ldeaves6v@state.tx.us	2036-11-15
249	Vivyanne	Lanyon	凰羽	vlanyon6w@barnesandnoble.com	1969-09-16
250	Kellen	Deason	\N	250@fajna_biblioteka_2137.pl	2021-06-09
251	Roarke	Archbould	\N	251@fajna_biblioteka_2137.pl	2021-06-09
252	Trula	Diego	\N	252@fajna_biblioteka_2137.pl	2021-06-09
253	Iris	Gunter	\N	253@fajna_biblioteka_2137.pl	2021-06-09
254	Megan	Quantrill	浩霖	mquantrill71@unesco.org	1978-02-26
255	Demetri	Bodemeaid	\N	255@fajna_biblioteka_2137.pl	2021-06-09
256	Kelvin	Parham	\N	256@fajna_biblioteka_2137.pl	2021-06-09
257	Julee	Ditch	宸瑜	jditch74@ucoz.com	2098-08-08
258	Ashil	Banke	轩硕	abanke75@gizmodo.com	2071-07-13
259	Hilary	Bentham	\N	259@fajna_biblioteka_2137.pl	2021-06-09
260	Georgianne	Pohl	孜绍	gpohl77@yellowbook.com	2072-08-24
261	Ivett	Gipp	\N	261@fajna_biblioteka_2137.pl	2021-06-09
262	Kennett	Skule	\N	262@fajna_biblioteka_2137.pl	2021-06-09
263	Sascha	Dickons	品逸	sdickons7a@virginia.edu	2025-05-28
264	Merwin	Espina	尹智	mespina7b@shinystat.com	1969-12-03
265	Solly	Larkings	秩选	slarkings7c@seesaa.net	1947-07-25
266	Kellsie	Stannus	澄泓	kstannus7d@google.ru	1971-03-20
267	Catlin	Sikora	尹智	csikora7e@cam.ac.uk	2087-03-19
268	Aggi	Collymore	秩选	acollymore7f@sogou.com	2068-11-09
269	Teddie	Felgat	\N	269@fajna_biblioteka_2137.pl	2021-06-09
270	Curry	McCutheon	彦军	cmccutheon7h@wsj.com	1976-08-27
271	Glenden	Sheardown	美莲	gsheardown7i@photobucket.com	1939-02-11
272	Terencio	Caltera	\N	272@fajna_biblioteka_2137.pl	2021-06-09
273	Vonnie	Muscat	烨伟	vmuscat7k@examiner.com	1951-02-11
274	Timotheus	Scneider	怡香	tscneider7l@statcounter.com	2042-03-30
275	Demetria	Kyrkeman	\N	275@fajna_biblioteka_2137.pl	2021-06-09
276	Shaylynn	Tight	\N	276@fajna_biblioteka_2137.pl	2021-06-09
277	Rurik	Lowdeane	昕磊	rlowdeane7o@nyu.edu	1939-01-26
278	Arnuad	Falkinder	\N	278@fajna_biblioteka_2137.pl	2021-06-09
279	Adelaida	Lowfill	\N	279@fajna_biblioteka_2137.pl	2021-06-09
280	Forrest	Middleton	\N	280@fajna_biblioteka_2137.pl	2021-06-09
281	Chelsea	Brokenbrow	思宏	cbrokenbrow7s@gravatar.com	1930-04-20
282	Meredeth	Pellew	哲恒	mpellew7t@1und1.de	2099-12-19
283	Bastian	Spilstead	亦涵	bspilstead7u@linkedin.com	1959-05-28
284	Haze	Arntzen	\N	284@fajna_biblioteka_2137.pl	2021-06-09
285	Tiena	Tobias	辰华	ttobias7w@adobe.com	2001-01-03
286	Benji	Walby	秩选	bwalby7x@goo.ne.jp	2088-11-08
287	Roarke	Henningham	博豪	rhenningham7y@cbslocal.com	1906-06-26
288	Kimberlyn	Hullock	\N	288@fajna_biblioteka_2137.pl	2021-06-09
289	Quint	Farries	浩成	qfarries80@wisc.edu	1993-06-21
290	Abbi	Whatmough	\N	290@fajna_biblioteka_2137.pl	2021-06-09
291	Caresa	Kerman	昕磊	ckerman82@gnu.org	1942-07-30
292	Leigha	McPartlin	\N	292@fajna_biblioteka_2137.pl	2021-06-09
293	Papageno	Stiebler	清凌	pstiebler84@shinystat.com	2039-07-16
294	Netti	Ludgate	\N	294@fajna_biblioteka_2137.pl	2021-06-09
295	Jessamine	Simonato	远帆	jsimonato86@europa.eu	2061-01-03
296	Eliza	McGaughay	澄泓	emcgaughay87@wikispaces.com	1987-09-03
297	Fonzie	Sorbie	\N	297@fajna_biblioteka_2137.pl	2021-06-09
298	Davida	Hyndman	\N	298@fajna_biblioteka_2137.pl	2021-06-09
299	Kort	Gatchell	\N	299@fajna_biblioteka_2137.pl	2021-06-09
300	Cecilius	Shemelt	\N	300@fajna_biblioteka_2137.pl	2021-06-09
301	Ewell	Moyle	\N	301@fajna_biblioteka_2137.pl	2021-06-09
302	Brit	Chotty	\N	302@fajna_biblioteka_2137.pl	2021-06-09
303	Roman	Dovermann	孜绍	rdovermann8e@simplemachines.org	2084-03-02
304	Kittie	Pantry	\N	304@fajna_biblioteka_2137.pl	2021-06-09
305	Joeann	Rubens	\N	305@fajna_biblioteka_2137.pl	2021-06-09
306	Frazer	Iddiens	瀚聪	fiddiens8h@thetimes.co.uk	2087-12-12
307	Cally	Waldera	\N	307@fajna_biblioteka_2137.pl	2021-06-09
308	Kayla	McMillian	\N	308@fajna_biblioteka_2137.pl	2021-06-09
309	Brinn	Colleck	\N	309@fajna_biblioteka_2137.pl	2021-06-09
310	Wynnie	Iacovolo	佐仪	wiacovolo8l@forbes.com	1922-02-24
311	Gregory	Hamor	思宏	ghamor8m@alibaba.com	1964-03-29
312	Frants	Charles	\N	312@fajna_biblioteka_2137.pl	2021-06-09
313	Goran	Olczak	琪煜	golczak8o@omniture.com	2042-06-20
314	Dee	Deverson	俊誉	ddeverson8p@weather.com	1993-09-22
315	Dukey	Willimont	\N	315@fajna_biblioteka_2137.pl	2021-06-09
316	Alric	Gaither	\N	316@fajna_biblioteka_2137.pl	2021-06-09
317	Paulita	Swinnard	远帆	pswinnard8s@ihg.com	2090-12-18
318	Katharina	O'Cooney	\N	318@fajna_biblioteka_2137.pl	2021-06-09
319	Gregoire	Lounds	泽瀚	glounds8u@smh.com.au	1999-10-12
320	Jameson	Andrewartha	尹智	jandrewartha8v@irs.gov	1950-09-16
321	Ware	La Rosa	泰霖	wlarosa8w@utexas.edu	2042-12-08
322	Enid	Bannon	\N	322@fajna_biblioteka_2137.pl	2021-06-09
323	Eyde	Chansonnau	\N	323@fajna_biblioteka_2137.pl	2021-06-09
324	Meggi	Click	云哲	mclick8z@hatena.ne.jp	2040-02-13
325	Iolande	Ishak	\N	325@fajna_biblioteka_2137.pl	2021-06-09
326	Alphonse	Battell	\N	326@fajna_biblioteka_2137.pl	2021-06-09
327	Lotta	Blamire	宇涵	lblamire92@sogou.com	2053-05-07
328	Ferdinande	Sichardt	睿杰	fsichardt93@diigo.com	1924-05-23
329	Brinn	Bettesworth	梦婷	bbettesworth94@myspace.com	2087-10-26
330	Grata	Welch	淑颖	gwelch95@wordpress.com	1931-03-07
331	Ellette	Attow	剑波	eattow96@w3.org	1979-09-17
332	Torrie	Darker	\N	332@fajna_biblioteka_2137.pl	2021-06-09
333	Cord	Knightsbridge	\N	333@fajna_biblioteka_2137.pl	2021-06-09
334	Marjorie	Frostdyke	\N	334@fajna_biblioteka_2137.pl	2021-06-09
335	Lelah	Dobsons	梓彤	ldobsons9a@unblog.fr	2053-08-04
336	Edward	Bauser	梓彤	ebauser9b@fc2.com	2007-11-11
337	Carlie	Bever	莉姿	cbever9c@dell.com	1915-07-30
338	Herschel	Shall	轩硕	hshall9d@printfriendly.com	2034-09-22
339	Terri	MacTague	佐仪	tmactague9e@vk.com	2024-09-23
340	Brendis	Brocklebank	可馨	bbrocklebank9f@tripadvisor.com	2027-12-28
341	Annabella	Dellatorre	军卿	adellatorre9g@csmonitor.com	2068-08-13
342	Demetris	Keveren	笑薇	dkeveren9h@histats.com	1924-05-03
343	Barrie	Terbrugge	烨伟	bterbrugge9i@craigslist.org	2001-07-20
344	Maje	Torrese	\N	344@fajna_biblioteka_2137.pl	2021-06-09
345	Elonore	Lomas	思翰	elomas9k@indiatimes.com	2080-05-12
346	Mirella	Burds	\N	346@fajna_biblioteka_2137.pl	2021-06-09
347	Fabiano	Bremmer	博豪	fbremmer9m@vistaprint.com	1908-02-01
348	Marcille	Taffley	莉姿	mtaffley9n@blogs.com	1946-09-24
349	Valenka	Fost	\N	349@fajna_biblioteka_2137.pl	2021-06-09
350	Roxy	Bloxsom	\N	350@fajna_biblioteka_2137.pl	2021-06-09
351	Gardener	Andrea	\N	351@fajna_biblioteka_2137.pl	2021-06-09
352	Benjamin	Cattroll	\N	352@fajna_biblioteka_2137.pl	2021-06-09
353	Brewer	Hendricks	海程	bhendricks9s@de.vu	1991-10-05
354	Marta	Trevascus	梓彤	mtrevascus9t@blog.com	1900-06-04
355	Richie	Muris	\N	355@fajna_biblioteka_2137.pl	2021-06-09
356	Yettie	Sissland	\N	356@fajna_biblioteka_2137.pl	2021-06-09
357	Glenna	Grenshiels	辰华	ggrenshiels9w@mtv.com	2035-06-27
358	Anjanette	Kupis	海程	akupis9x@webeden.co.uk	1902-05-24
359	Sly	Sugars	云哲	ssugars9y@europa.eu	1953-02-17
360	Barry	Cretney	惠茜	bcretney9z@go.com	1914-07-16
361	Avictor	Rapps	\N	361@fajna_biblioteka_2137.pl	2021-06-09
362	Cob	Brotherhood	\N	362@fajna_biblioteka_2137.pl	2021-06-09
363	Briny	Ivanyukov	\N	363@fajna_biblioteka_2137.pl	2021-06-09
364	Osbourn	Dews	泰霖	odewsa3@huffingtonpost.com	1908-09-15
365	Ward	Swettenham	羽彤	wswettenhama4@tmall.com	2049-11-10
366	Crista	Hesbrook	伟宸	chesbrooka5@google.com.au	2034-05-06
367	Mac	Swindells	丰逸	mswindellsa6@mysql.com	2011-06-24
368	Lombard	Olech	\N	368@fajna_biblioteka_2137.pl	2021-06-09
369	Pauletta	Sheddan	\N	369@fajna_biblioteka_2137.pl	2021-06-09
370	Dewitt	Gossipin	\N	370@fajna_biblioteka_2137.pl	2021-06-09
371	Jacques	Haddy	\N	371@fajna_biblioteka_2137.pl	2021-06-09
372	Ase	Hicken	宸赫	ahickenab@g.co	1908-10-13
373	Marquita	Minico	昕磊	mminicoac@cam.ac.uk	1916-10-28
374	Erick	Easson	俊誉	eeassonad@smh.com.au	1943-09-21
375	Constantine	Prall	月松	cprallae@chicagotribune.com	1926-03-12
376	Sondra	Iban	\N	376@fajna_biblioteka_2137.pl	2021-06-09
377	Ira	Cleobury	\N	377@fajna_biblioteka_2137.pl	2021-06-09
378	Malcolm	Roderick	宸瑜	mroderickah@scientificamerican.com	2001-03-15
379	Jone	Lightning	\N	379@fajna_biblioteka_2137.pl	2021-06-09
380	Nikos	Kingswold	\N	380@fajna_biblioteka_2137.pl	2021-06-09
381	Ileane	Conford	\N	381@fajna_biblioteka_2137.pl	2021-06-09
382	Kate	McDermot	\N	382@fajna_biblioteka_2137.pl	2021-06-09
383	Ollie	Fearne	\N	383@fajna_biblioteka_2137.pl	2021-06-09
384	Bernardina	Woller	丰逸	bwolleran@home.pl	1921-08-23
385	Conrad	Paulmann	昕磊	cpaulmannao@discuz.net	2098-02-16
386	Tracie	Blaydes	剑波	tblaydesap@cornell.edu	1970-07-29
387	Debor	Hufton	\N	387@fajna_biblioteka_2137.pl	2021-06-09
388	Jacqueline	Stookes	\N	388@fajna_biblioteka_2137.pl	2021-06-09
389	Hurlee	Calley	雨婷	hcalleyas@bing.com	1918-01-14
390	Octavia	Carnoghan	\N	390@fajna_biblioteka_2137.pl	2021-06-09
391	Cassie	Cowdrey	凰羽	ccowdreyau@google.cn	1983-12-31
392	Georgine	Levene	\N	392@fajna_biblioteka_2137.pl	2021-06-09
393	Viki	Doale	\N	393@fajna_biblioteka_2137.pl	2021-06-09
394	Theodor	Brotherhead	\N	394@fajna_biblioteka_2137.pl	2021-06-09
395	Christabel	de Banke	鑫蕾	cdebankeay@hexun.com	1962-10-23
396	Arnaldo	Sayles	\N	396@fajna_biblioteka_2137.pl	2021-06-09
397	Nanine	Yole	\N	397@fajna_biblioteka_2137.pl	2021-06-09
398	Magdaia	Rohlfs	\N	398@fajna_biblioteka_2137.pl	2021-06-09
399	Nelly	Triplett	\N	399@fajna_biblioteka_2137.pl	2021-06-09
400	Regan	Snibson	睿杰	rsnibsonb3@about.me	2076-01-14
401	Ilka	MacDermott	皓睿	imacdermottb4@auda.org.au	2038-10-25
402	Margette	Worsham	\N	402@fajna_biblioteka_2137.pl	2021-06-09
403	Marv	Poff	晧宇	mpoffb6@addthis.com	1961-08-29
404	Maddi	Proughten	\N	404@fajna_biblioteka_2137.pl	2021-06-09
405	Flin	Adam	孜绍	fadamb8@businessinsider.com	1992-09-25
406	Leigha	Ply	碧萱	lplyb9@unesco.org	2059-03-02
407	Gypsy	Kingscott	鑫蕾	gkingscottba@aboutads.info	2029-05-14
408	Sula	Sweeny	尹智	ssweenybb@odnoklassniki.ru	2081-12-22
409	Auria	Delafont	\N	409@fajna_biblioteka_2137.pl	2021-06-09
410	Farrand	Lammerding	晓烽	flammerdingbd@weibo.com	2029-05-01
411	Allina	Ielden	尹智	aieldenbe@fema.gov	2036-08-15
412	Darb	McAmish	志宸	dmcamishbf@quantcast.com	1928-08-04
413	Delores	Kielty	品逸	dkieltybg@wikimedia.org	2023-05-16
414	Meriel	Wyldbore	\N	414@fajna_biblioteka_2137.pl	2021-06-09
415	Halimeda	Jendricke	\N	415@fajna_biblioteka_2137.pl	2021-06-09
416	Garth	Blondin	\N	416@fajna_biblioteka_2137.pl	2021-06-09
417	Lindie	Hickin	\N	417@fajna_biblioteka_2137.pl	2021-06-09
418	Nicolina	Correa	\N	418@fajna_biblioteka_2137.pl	2021-06-09
419	Calley	Blaszczak	\N	419@fajna_biblioteka_2137.pl	2021-06-09
420	Ricardo	Beaten	\N	420@fajna_biblioteka_2137.pl	2021-06-09
421	Anett	Aylott	\N	421@fajna_biblioteka_2137.pl	2021-06-09
422	Van	Juarez	琪煜	vjuarezbp@abc.net.au	2031-04-01
423	Amalee	Santoro	博裕	asantorobq@skype.com	2020-05-26
424	Burl	Hachard	\N	424@fajna_biblioteka_2137.pl	2021-06-09
425	Darby	Truett	辰华	dtruettbs@paginegialle.it	2053-07-03
426	Herta	Wheater	\N	426@fajna_biblioteka_2137.pl	2021-06-09
427	Genvieve	Trymme	\N	427@fajna_biblioteka_2137.pl	2021-06-09
428	Penny	Gadeaux	雨嘉	pgadeauxbv@wix.com	1924-01-04
429	Naomi	Fairbard	\N	429@fajna_biblioteka_2137.pl	2021-06-09
430	Ulla	St Louis	彤雨	ustlouisbx@amazon.co.jp	1963-07-26
431	Vaughn	Handman	\N	431@fajna_biblioteka_2137.pl	2021-06-09
432	Parke	Kedward	思翰	pkedwardbz@multiply.com	2062-12-07
433	Ettie	Brimblecomb	\N	433@fajna_biblioteka_2137.pl	2021-06-09
434	Nathanial	Gobat	\N	434@fajna_biblioteka_2137.pl	2021-06-09
435	Wynne	Shill	\N	435@fajna_biblioteka_2137.pl	2021-06-09
436	Benjamen	Batten	\N	436@fajna_biblioteka_2137.pl	2021-06-09
437	Joelle	Dewire	伟菘	jdewirec4@earthlink.net	2014-01-29
438	Ofella	Watkiss	琪煜	owatkissc5@huffingtonpost.com	1971-11-02
439	Sibylle	Tibb	\N	439@fajna_biblioteka_2137.pl	2021-06-09
440	Griff	Bownde	\N	440@fajna_biblioteka_2137.pl	2021-06-09
441	Rudy	Lavies	烨伟	rlaviesc8@sciencedaily.com	2089-08-26
442	Roselia	Currin	\N	442@fajna_biblioteka_2137.pl	2021-06-09
443	Ginevra	Brownsmith	宸赫	gbrownsmithca@mozilla.com	2034-12-20
444	Tessi	Furlong	梓彤	tfurlongcb@dot.gov	1999-11-23
445	Daron	Shynn	\N	445@fajna_biblioteka_2137.pl	2021-06-09
446	Ahmad	Jovovic	龙胜	ajovoviccd@zimbio.com	2042-09-08
447	Charmain	Leyden	晓晴	cleydence@mayoclinic.com	1912-07-05
448	Seana	Ranking	\N	448@fajna_biblioteka_2137.pl	2021-06-09
449	Lorianne	Lembrick	鑫蕾	llembrickcg@instagram.com	1934-01-30
450	Tawnya	Eyree	伟菘	teyreech@feedburner.com	2090-02-12
451	Caty	Carvilla	\N	451@fajna_biblioteka_2137.pl	2021-06-09
452	Edward	Sebastian	宇涵	esebastiancj@scientificamerican.com	2083-06-26
453	Jobi	Nettleship	\N	453@fajna_biblioteka_2137.pl	2021-06-09
454	Greer	Sorbie	\N	454@fajna_biblioteka_2137.pl	2021-06-09
455	Tessi	Roderigo	\N	455@fajna_biblioteka_2137.pl	2021-06-09
456	Melva	Pittle	浩成	mpittlecn@go.com	1984-09-26
457	Rhoda	Chatan	\N	457@fajna_biblioteka_2137.pl	2021-06-09
458	Cristy	Knappen	澄泓	cknappencp@dropbox.com	2003-06-10
459	Kenton	Dogerty	\N	459@fajna_biblioteka_2137.pl	2021-06-09
460	Deeanne	Breydin	\N	460@fajna_biblioteka_2137.pl	2021-06-09
461	Barbey	Hoston	\N	461@fajna_biblioteka_2137.pl	2021-06-09
462	Terese	Emberton	\N	462@fajna_biblioteka_2137.pl	2021-06-09
463	Montgomery	Pele	\N	463@fajna_biblioteka_2137.pl	2021-06-09
464	Dorine	Serck	\N	464@fajna_biblioteka_2137.pl	2021-06-09
465	Byram	Coppeard	\N	465@fajna_biblioteka_2137.pl	2021-06-09
466	Barbie	Berecloth	墨含	bbereclothcx@t.co	2002-09-25
467	Lena	Thomann	\N	467@fajna_biblioteka_2137.pl	2021-06-09
468	Domingo	Velden	\N	468@fajna_biblioteka_2137.pl	2021-06-09
469	Errol	Rampage	浩成	erampaged0@reverbnation.com	1904-09-24
470	Gertrud	Fearon	\N	470@fajna_biblioteka_2137.pl	2021-06-09
471	Glyn	Sarfass	\N	471@fajna_biblioteka_2137.pl	2021-06-09
472	Chadd	Waterdrinker	\N	472@fajna_biblioteka_2137.pl	2021-06-09
473	Chevalier	Divall	思宇	cdivalld4@dropbox.com	2078-10-20
474	Ansley	Shrimplin	烨伟	ashrimplind5@imageshack.us	1970-08-22
475	Teresa	McCuaig	\N	475@fajna_biblioteka_2137.pl	2021-06-09
476	Livvie	Eirwin	宸瑜	leirwind7@cbslocal.com	1921-04-19
477	Tomasine	Jerwood	晓烽	tjerwoodd8@stanford.edu	1962-02-21
478	Kin	Dassindale	玺越	kdassindaled9@people.com.cn	1939-03-10
479	Stacee	Reaman	宸赫	sreamanda@rakuten.co.jp	2002-09-09
480	Fair	Epgrave	品逸	fepgravedb@tinyurl.com	1944-06-20
481	Rabbi	Bier	浩成	rbierdc@zimbio.com	1966-01-31
482	Constantia	Gianelli	晓晴	cgianellidd@whitehouse.gov	2093-04-25
483	Joli	Knapman	\N	483@fajna_biblioteka_2137.pl	2021-06-09
484	Gordy	Tregidga	辰华	gtregidgadf@booking.com	2089-02-07
485	Zacharia	Kubalek	\N	485@fajna_biblioteka_2137.pl	2021-06-09
486	Jaclyn	Maycey	雪丽	jmayceydh@seattletimes.com	1911-01-31
487	Devinne	Blabey	\N	487@fajna_biblioteka_2137.pl	2021-06-09
488	Merilee	Huffer	博裕	mhufferdj@is.gd	2075-11-26
489	Cynthea	Tumpane	萧然	ctumpanedk@github.com	1956-11-09
490	Alayne	Siege	若瑾	asiegedl@list-manage.com	2056-12-31
491	Torrance	Pikett	皓睿	tpikettdm@pbs.org	2030-05-26
492	Carlie	Murrey	\N	492@fajna_biblioteka_2137.pl	2021-06-09
493	Nelli	Hammant	\N	493@fajna_biblioteka_2137.pl	2021-06-09
494	Lawry	Eteen	昱漳	leteendp@cbsnews.com	1962-08-31
495	Tuesday	Mumford	惠茜	tmumforddq@amazonaws.com	2043-10-18
496	Enrica	Eagell	\N	496@fajna_biblioteka_2137.pl	2021-06-09
497	Noella	Pettyfer	\N	497@fajna_biblioteka_2137.pl	2021-06-09
498	Lyn	Waple	浩成	lwapledt@unblog.fr	1963-03-04
499	Bernardine	Hallahan	梓彤	bhallahandu@example.com	2074-09-16
500	Cale	Zuenelli	松源	czuenellidv@zdnet.com	1995-03-24
501	Dede	Vlasenko	\N	501@fajna_biblioteka_2137.pl	2021-06-09
502	Welbie	Della	晧宇	wdelladx@free.fr	1937-10-28
503	Kristin	Duro	\N	503@fajna_biblioteka_2137.pl	2021-06-09
504	Janaya	Friel	\N	504@fajna_biblioteka_2137.pl	2021-06-09
505	Annmaria	Pye	\N	505@fajna_biblioteka_2137.pl	2021-06-09
506	Angus	Erwin	\N	506@fajna_biblioteka_2137.pl	2021-06-09
507	Jermayne	McKenzie	\N	507@fajna_biblioteka_2137.pl	2021-06-09
508	Katlin	Coundley	博裕	kcoundleye3@google.co.jp	1938-06-28
509	Luisa	Churching	婧琪	lchurchinge4@wordpress.com	2087-05-13
510	Norene	Keilty	\N	510@fajna_biblioteka_2137.pl	2021-06-09
511	Rheta	Drust	\N	511@fajna_biblioteka_2137.pl	2021-06-09
512	Selma	Grimme	\N	512@fajna_biblioteka_2137.pl	2021-06-09
513	Yehudi	Judge	\N	513@fajna_biblioteka_2137.pl	2021-06-09
514	Bank	Potzold	辰华	bpotzolde9@examiner.com	2067-03-21
515	Meggie	Pauly	琪煜	mpaulyea@t-online.de	1907-01-05
516	Meghan	Chellingworth	\N	516@fajna_biblioteka_2137.pl	2021-06-09
517	Bettye	Rawling	浩成	brawlingec@mediafire.com	1984-08-16
518	Conchita	Endacott	琪煜	cendacotted@wikimedia.org	1919-01-15
519	Augustin	Castilla	\N	519@fajna_biblioteka_2137.pl	2021-06-09
520	Althea	Frudd	\N	520@fajna_biblioteka_2137.pl	2021-06-09
521	Codi	Darbey	云哲	cdarbeyeg@tuttocitta.it	1905-04-16
522	Malissa	Walton	澄泓	mwaltoneh@tumblr.com	2034-08-18
523	Chrotoem	Garlant	俊誉	cgarlantei@china.com.cn	1965-10-31
524	Brent	Cobain	彦歆	bcobainej@trellian.com	2070-08-30
525	Kylie	Gilmore	\N	525@fajna_biblioteka_2137.pl	2021-06-09
526	Garrard	Dawtre	雨婷	gdawtreel@blogspot.com	2030-09-30
527	Dyna	Scurfield	\N	527@fajna_biblioteka_2137.pl	2021-06-09
528	Natalya	Leeburne	泽瀚	nleeburneen@homestead.com	2021-01-20
529	Eldon	Duns	\N	529@fajna_biblioteka_2137.pl	2021-06-09
530	Shel	Powling	雨嘉	spowlingep@storify.com	2038-04-26
531	Kay	Badini	\N	531@fajna_biblioteka_2137.pl	2021-06-09
532	Winfred	Morfield	墨含	wmorfielder@mail.ru	2046-01-07
533	Tiffy	Manifould	思宇	tmanifouldes@yahoo.co.jp	1988-04-21
534	Laughton	Kindle	\N	534@fajna_biblioteka_2137.pl	2021-06-09
535	Billie	Losseljong	\N	535@fajna_biblioteka_2137.pl	2021-06-09
536	Rufus	Kelle	佐仪	rkelleev@feedburner.com	2021-01-24
537	Morena	Fernant	辰华	mfernantew@mtv.com	2045-07-02
538	Dolly	Phateplace	\N	538@fajna_biblioteka_2137.pl	2021-06-09
539	Betti	Barnson	唯枫	bbarnsoney@pagesperso-orange.fr	2068-12-25
540	Inga	Jeremaes	泽瀚	ijeremaesez@cnn.com	1937-05-24
541	Dante	Vagges	嫦曦	dvaggesf0@multiply.com	1924-06-24
542	Berkeley	O'Shesnan	\N	542@fajna_biblioteka_2137.pl	2021-06-09
543	Bondie	Soane	梓彤	bsoanef2@google.cn	1988-12-26
544	Laurel	Stokell	\N	544@fajna_biblioteka_2137.pl	2021-06-09
545	Bertie	Tabary	\N	545@fajna_biblioteka_2137.pl	2021-06-09
546	Elwood	Pennington	\N	546@fajna_biblioteka_2137.pl	2021-06-09
547	Emmy	Foyle	\N	547@fajna_biblioteka_2137.pl	2021-06-09
548	Malchy	Noye	伟菘	mnoyef7@cisco.com	1963-05-09
549	Niko	Longford	\N	549@fajna_biblioteka_2137.pl	2021-06-09
550	Wilburt	Walshe	\N	550@fajna_biblioteka_2137.pl	2021-06-09
551	Maurice	Aykroyd	静香	maykroydfa@wikimedia.org	1973-09-10
552	Lacie	Delany	\N	552@fajna_biblioteka_2137.pl	2021-06-09
553	Hermie	Sent	\N	553@fajna_biblioteka_2137.pl	2021-06-09
554	Morton	Hise	伟宸	mhisefd@imageshack.us	1911-09-27
555	Dorris	Blockley	\N	555@fajna_biblioteka_2137.pl	2021-06-09
556	Birk	Giacopini	\N	556@fajna_biblioteka_2137.pl	2021-06-09
557	Husein	McMorland	\N	557@fajna_biblioteka_2137.pl	2021-06-09
558	Aloin	Iacovuzzi	\N	558@fajna_biblioteka_2137.pl	2021-06-09
559	Simonne	Zielinski	孜绍	szielinskifi@wikispaces.com	1984-12-16
560	Maje	Keetley	远帆	mkeetleyfj@multiply.com	1910-04-23
561	Bernardo	Gianilli	云哲	bgianillifk@ihg.com	2058-11-19
562	Bobbie	Costock	\N	562@fajna_biblioteka_2137.pl	2021-06-09
563	Zonda	Strain	\N	563@fajna_biblioteka_2137.pl	2021-06-09
564	Benjamin	Leban	秩选	blebanfn@mlb.com	1923-12-23
565	Enriqueta	Cicutto	\N	565@fajna_biblioteka_2137.pl	2021-06-09
566	Lorens	Towner	琪煜	ltownerfp@unicef.org	2064-10-08
567	Pierce	Stockbridge	志宸	pstockbridgefq@wp.com	1923-03-13
568	Kingsley	Fairall	凰羽	kfairallfr@oaic.gov.au	1928-06-03
569	Gib	Sillito	亦涵	gsillitofs@woothemes.com	2085-02-22
570	Anatollo	Flecknell	\N	570@fajna_biblioteka_2137.pl	2021-06-09
571	Cecilia	Tocque	\N	571@fajna_biblioteka_2137.pl	2021-06-09
572	Victoria	Biasio	宸瑜	vbiasiofv@engadget.com	1901-04-24
573	Opal	Mence	\N	573@fajna_biblioteka_2137.pl	2021-06-09
574	Gerry	Vear	\N	574@fajna_biblioteka_2137.pl	2021-06-09
575	Donnamarie	Nand	梦婷	dnandfy@mozilla.com	1906-06-04
576	Betsy	Bater	欣妍	bbaterfz@wikipedia.org	1950-11-29
577	Dawna	Pittam	轩硕	dpittamg0@simplemachines.org	2084-04-06
578	Stormi	Elgar	浩成	selgarg1@theatlantic.com	1935-02-24
579	Torr	Mawtus	\N	579@fajna_biblioteka_2137.pl	2021-06-09
580	Minne	Muffett	淑颖	mmuffettg3@omniture.com	2041-06-09
581	Meaghan	Hay	漫妮	mhayg4@blogspot.com	1963-02-23
582	Zacherie	Curreen	彤雨	zcurreeng5@biblegateway.com	1938-09-21
583	Nessie	Littleover	培安	nlittleoverg6@epa.gov	1969-07-05
584	Charlotte	Kinloch	\N	584@fajna_biblioteka_2137.pl	2021-06-09
585	Cesar	Haslum	冠泽	chaslumg8@google.com.br	1979-10-30
586	Emlynn	Mitchley	雪怡	emitchleyg9@vistaprint.com	2011-10-26
587	Tan	McEntee	\N	587@fajna_biblioteka_2137.pl	2021-06-09
588	Marsha	Filyakov	丰逸	mfilyakovgb@infoseek.co.jp	1902-11-06
589	Jackie	Russell	\N	589@fajna_biblioteka_2137.pl	2021-06-09
590	Tamqrah	Mammatt	梦婷	tmammattgd@cbsnews.com	2003-02-07
591	Hamish	Enticknap	\N	591@fajna_biblioteka_2137.pl	2021-06-09
592	Leeanne	Northedge	冠泽	lnorthedgegf@hhs.gov	1961-08-16
593	Nettle	Fosdike	宸瑜	nfosdikegg@upenn.edu	1969-11-04
594	Babita	Pryce	孜绍	bprycegh@businessinsider.com	1969-02-06
595	Andy	Yaneev	晓晴	ayaneevgi@printfriendly.com	2070-06-13
596	Kellia	Hultberg	博豪	khultberggj@wikipedia.org	1917-07-18
597	Sheffield	Abramof	松源	sabramofgk@google.de	1924-10-28
598	Julissa	Donnellan	美琳	jdonnellangl@examiner.com	2085-08-08
599	Idelle	Yves	\N	599@fajna_biblioteka_2137.pl	2021-06-09
600	John	Gerholz	\N	600@fajna_biblioteka_2137.pl	2021-06-09
601	Gage	McCoish	轩硕	gmccoishgo@si.edu	2094-12-30
602	Damon	Merriday	\N	602@fajna_biblioteka_2137.pl	2021-06-09
603	Carlita	Crunkhorn	\N	603@fajna_biblioteka_2137.pl	2021-06-09
604	Innis	Fairburn	宸瑜	ifairburngr@pen.io	1921-12-06
605	Teddy	Fagg	凰羽	tfagggs@yahoo.com	1967-08-03
606	Padraig	Hailey	志宸	phaileygt@engadget.com	1940-12-19
607	Paddie	Dunbabin	\N	607@fajna_biblioteka_2137.pl	2021-06-09
608	Vevay	Lamplough	\N	608@fajna_biblioteka_2137.pl	2021-06-09
609	Bartie	Grissett	宸瑜	bgrissettgw@google.co.uk	2056-08-31
610	Broderic	Powney	海程	bpowneygx@google.nl	1941-02-24
611	Gilberta	Rushforth	\N	611@fajna_biblioteka_2137.pl	2021-06-09
612	Mendy	Giraudy	\N	612@fajna_biblioteka_2137.pl	2021-06-09
613	Sam	Heaffey	辰华	sheaffeyh0@hhs.gov	1967-02-07
614	Gabie	Bonas	\N	614@fajna_biblioteka_2137.pl	2021-06-09
615	Seymour	Forde	\N	615@fajna_biblioteka_2137.pl	2021-06-09
616	Gwenore	Kestin	若瑾	gkestinh3@howstuffworks.com	1979-05-06
617	Bonnee	Vaillant	\N	617@fajna_biblioteka_2137.pl	2021-06-09
618	Vanny	Reeson	晓晴	vreesonh5@state.tx.us	1952-11-09
619	Reeba	Golsby	泰霖	rgolsbyh6@godaddy.com	2099-03-30
620	Beniamino	Back	美琳	bbackh7@imgur.com	1946-03-12
621	Philis	Stark	鑫蕾	pstarkh8@howstuffworks.com	2089-10-10
622	Tobiah	Gobbett	永鑫	tgobbetth9@tinypic.com	2005-01-20
623	Ernesta	Colquite	彤雨	ecolquiteha@github.io	1906-03-01
624	Elva	Crofthwaite	\N	624@fajna_biblioteka_2137.pl	2021-06-09
625	Parsifal	Ashmore	博豪	pashmorehc@blogspot.com	2063-05-21
626	Hermann	Adacot	俊泽	hadacothd@seattletimes.com	1956-08-21
627	Kayne	Taylerson	培安	ktaylersonhe@nba.com	1932-01-21
628	Oliviero	Vautre	轩硕	ovautrehf@macromedia.com	1953-03-14
629	Milt	Probart	\N	629@fajna_biblioteka_2137.pl	2021-06-09
630	Maryjane	O'Dempsey	婧琪	modempseyhh@nyu.edu	1984-08-15
631	Eryn	Dacks	尚霖	edackshi@amazon.com	2041-05-31
632	Audy	Hamshar	展博	ahamsharhj@chicagotribune.com	2093-09-28
633	Ingrim	Snowdon	萧然	isnowdonhk@microsoft.com	2045-06-13
634	Zebedee	Eberst	\N	634@fajna_biblioteka_2137.pl	2021-06-09
635	Kameko	Devereu	\N	635@fajna_biblioteka_2137.pl	2021-06-09
636	Alfons	Panchin	\N	636@fajna_biblioteka_2137.pl	2021-06-09
637	Ronnie	Gon	碧萱	rgonho@studiopress.com	1900-07-01
638	Sigismond	Dettmar	\N	638@fajna_biblioteka_2137.pl	2021-06-09
639	Erny	Iveagh	\N	639@fajna_biblioteka_2137.pl	2021-06-09
640	Artemus	Elbourn	\N	640@fajna_biblioteka_2137.pl	2021-06-09
641	Louis	Reddel	\N	641@fajna_biblioteka_2137.pl	2021-06-09
642	Lea	Packington	\N	642@fajna_biblioteka_2137.pl	2021-06-09
643	Lanette	Penhearow	\N	643@fajna_biblioteka_2137.pl	2021-06-09
644	Renell	Adamiak	展博	radamiakhv@army.mil	2012-05-09
645	Cornelia	Popham	宸瑜	cpophamhw@nationalgeographic.com	1988-07-21
646	Trev	McCreagh	\N	646@fajna_biblioteka_2137.pl	2021-06-09
647	Darelle	Nutley	银涵	dnutleyhy@irs.gov	1965-10-18
648	Darrel	Sieb	\N	648@fajna_biblioteka_2137.pl	2021-06-09
649	Cletus	Bambrick	\N	649@fajna_biblioteka_2137.pl	2021-06-09
650	Theresita	Drane	婧琪	tdranei1@usnews.com	2043-03-25
651	Northrop	Comport	\N	651@fajna_biblioteka_2137.pl	2021-06-09
652	Andeee	Gorman	\N	652@fajna_biblioteka_2137.pl	2021-06-09
653	Alfredo	Nother	凰羽	anotheri4@angelfire.com	1903-06-24
654	Starlin	Purtell	轩硕	spurtelli5@icq.com	1954-09-22
655	Brittne	Jansky	晧宇	bjanskyi6@google.de	2047-07-17
656	Kendrick	Merry	\N	656@fajna_biblioteka_2137.pl	2021-06-09
657	Connie	Whytock	\N	657@fajna_biblioteka_2137.pl	2021-06-09
658	Emyle	Farahar	\N	658@fajna_biblioteka_2137.pl	2021-06-09
659	Kimberlyn	Sarchwell	\N	659@fajna_biblioteka_2137.pl	2021-06-09
660	Wendy	Bresson	\N	660@fajna_biblioteka_2137.pl	2021-06-09
661	Nani	Fechnie	\N	661@fajna_biblioteka_2137.pl	2021-06-09
662	Meryl	Twatt	睿杰	mtwattid@purevolume.com	1939-05-09
663	Kaylee	de'-Ancy Willis	\N	663@fajna_biblioteka_2137.pl	2021-06-09
664	Saunderson	Brissenden	\N	664@fajna_biblioteka_2137.pl	2021-06-09
665	Oriana	Feeham	\N	665@fajna_biblioteka_2137.pl	2021-06-09
666	Rube	Hebson	羽彤	rhebsonih@php.net	2042-12-17
667	Kennith	Turfes	墨含	kturfesii@youtu.be	1914-05-14
668	Maure	Broadbere	茹雪	mbroadbereij@globo.com	1957-02-24
669	Fitz	Diemer	俊誉	fdiemerik@sogou.com	1965-08-22
670	Mirna	Tiron	冠泽	mtironil@studiopress.com	1993-07-01
671	Shantee	Roussel	若瑾	srousselim@nhs.uk	2020-04-27
672	Rowan	Meace	\N	672@fajna_biblioteka_2137.pl	2021-06-09
673	Weylin	Brimmell	韵寒	wbrimmellio@mapy.cz	1930-05-20
674	Antony	Gully	培安	agullyip@wordpress.org	1995-11-15
675	Sascha	Preddle	香茹	spreddleiq@phpbb.com	1925-02-28
676	Winona	Brackenbury	梦婷	wbrackenburyir@nifty.com	1994-11-19
677	Gwyn	Deares	睿杰	gdearesis@soundcloud.com	2068-11-05
678	Orson	Laffoley-Lane	可馨	olaffoleylaneit@sfgate.com	2034-06-27
679	Thaine	Stirrip	\N	679@fajna_biblioteka_2137.pl	2021-06-09
680	Carlina	Ashpital	\N	680@fajna_biblioteka_2137.pl	2021-06-09
681	Xavier	Fullwood	漫妮	xfullwoodiw@irs.gov	1909-06-21
682	Den	Backshill	\N	682@fajna_biblioteka_2137.pl	2021-06-09
683	Stefano	Ruvel	浩成	sruveliy@smugmug.com	1901-02-21
684	Nikola	Kiljan	思宏	nkiljaniz@fda.gov	2087-01-02
685	Blanche	Cattenach	\N	685@fajna_biblioteka_2137.pl	2021-06-09
686	Dalenna	Faires	雨嘉	dfairesj1@wp.com	2077-11-13
687	Shanan	Josiah	银涵	sjosiahj2@scribd.com	1905-09-12
688	Glynnis	Shermore	\N	688@fajna_biblioteka_2137.pl	2021-06-09
689	Amory	David	\N	689@fajna_biblioteka_2137.pl	2021-06-09
690	Cordula	McPake	彦军	cmcpakej5@hibu.com	2003-09-13
691	Richy	Dixcey	烨伟	rdixceyj6@typepad.com	1990-05-24
692	Tally	Brabant	\N	692@fajna_biblioteka_2137.pl	2021-06-09
693	Kerry	Thorp	博豪	kthorpj8@gmpg.org	1970-06-16
694	Miof mela	Latchmore	伟菘	mlatchmorej9@sitemeter.com	2024-06-03
695	Willy	MacNess	\N	695@fajna_biblioteka_2137.pl	2021-06-09
696	Rhys	Ends	雪怡	rendsjb@linkedin.com	1966-11-16
697	Madalena	Dunbar	\N	697@fajna_biblioteka_2137.pl	2021-06-09
698	Anestassia	Sherwen	若瑾	asherwenjd@indiatimes.com	1970-06-09
699	Sonnnie	Mattedi	佐仪	smattedije@hhs.gov	1991-03-08
700	Roscoe	Olander	品逸	rolanderjf@samsung.com	1907-08-15
701	Johnathon	Grishaev	\N	701@fajna_biblioteka_2137.pl	2021-06-09
702	Cynthea	Duffill	\N	702@fajna_biblioteka_2137.pl	2021-06-09
703	Floyd	Symers	\N	703@fajna_biblioteka_2137.pl	2021-06-09
704	Harrison	Hadlington	\N	704@fajna_biblioteka_2137.pl	2021-06-09
705	Dulce	Huke	雪怡	dhukejk@blogger.com	1976-07-27
706	Cosette	Frudd	思翰	cfruddjl@tinypic.com	2044-04-01
707	Wilfrid	Grinter	轩硕	wgrinterjm@nymag.com	1931-08-13
708	Delinda	Lead	永鑫	dleadjn@4shared.com	1962-04-17
709	Lorrie	Heinlein	\N	709@fajna_biblioteka_2137.pl	2021-06-09
710	Bessy	Parcells	银涵	bparcellsjp@cbc.ca	2088-02-15
711	West	Biddlecombe	尹智	wbiddlecombejq@lulu.com	2087-08-05
712	Thoma	Laird	\N	712@fajna_biblioteka_2137.pl	2021-06-09
713	Wes	Dessaur	孜绍	wdessaurjs@de.vu	2036-08-10
714	Simone	Dat	俞凯	sdatjt@lycos.com	2084-08-05
715	Jori	Pollins	\N	715@fajna_biblioteka_2137.pl	2021-06-09
716	Tabb	Vane	宇涵	tvanejv@plala.or.jp	1911-06-25
717	Giulia	Tregiddo	雨萌	gtregiddojw@usnews.com	1904-10-31
718	Bobette	Simm	\N	718@fajna_biblioteka_2137.pl	2021-06-09
719	Josefina	Nesbitt	丰逸	jnesbittjy@alexa.com	2081-12-06
720	Luce	Whorf	\N	720@fajna_biblioteka_2137.pl	2021-06-09
721	Josy	Triplett	远帆	jtriplettk0@bbb.org	2097-03-09
722	Fleur	Outridge	浩成	foutridgek1@photobucket.com	1944-04-20
723	Pernell	Sains	静香	psainsk2@google.com.au	1931-12-23
724	Cathee	Arstingall	辰华	carstingallk3@omniture.com	1977-07-22
725	Carey	Sterricker	羽彤	csterrickerk4@godaddy.com	2015-07-30
726	Pernell	Patient	\N	726@fajna_biblioteka_2137.pl	2021-06-09
727	Dewey	Dawtry	\N	727@fajna_biblioteka_2137.pl	2021-06-09
728	Brady	Luna	\N	728@fajna_biblioteka_2137.pl	2021-06-09
729	Marcos	Boice	博豪	mboicek8@tumblr.com	1991-02-28
730	Amity	Crucitti	莉姿	acrucittik9@i2i.jp	1922-09-01
731	Ariana	Storks	凰羽	astorkska@princeton.edu	2021-01-17
732	Eduino	Buttrey	昕磊	ebuttreykb@printfriendly.com	1966-11-14
733	Gib	Dudny	\N	733@fajna_biblioteka_2137.pl	2021-06-09
734	Marmaduke	Opy	\N	734@fajna_biblioteka_2137.pl	2021-06-09
735	Ruben	de Najera	志宸	rdenajerake@webnode.com	2011-04-17
736	Merle	Desforges	慧妍	mdesforgeskf@github.io	2037-08-06
737	Shay	Soans	冠泽	ssoanskg@yelp.com	1999-05-06
738	Noelani	Scobbie	\N	738@fajna_biblioteka_2137.pl	2021-06-09
739	Francesco	Witling	静香	fwitlingki@adobe.com	2003-05-12
740	Bronny	MacAulay	静香	bmacaulaykj@uol.com.br	1993-10-22
741	Myriam	Jaqueme	伟宸	mjaquemekk@naver.com	2031-07-22
742	Clayson	Dearing	\N	742@fajna_biblioteka_2137.pl	2021-06-09
743	Jaquenetta	D'Oyly	烨伟	jdoylykm@ebay.co.uk	2021-07-30
744	Rodger	Greedier	\N	744@fajna_biblioteka_2137.pl	2021-06-09
745	Corie	Goudge	\N	745@fajna_biblioteka_2137.pl	2021-06-09
746	Yorgo	Thickpenny	辰华	ythickpennykp@mediafire.com	1945-08-01
747	Tades	Newlyn	\N	747@fajna_biblioteka_2137.pl	2021-06-09
748	Dillie	Langrish	\N	748@fajna_biblioteka_2137.pl	2021-06-09
749	Normy	Stuttard	\N	749@fajna_biblioteka_2137.pl	2021-06-09
750	Roarke	Woolrich	\N	750@fajna_biblioteka_2137.pl	2021-06-09
751	Rodge	Boas	崇杉	rboasku@cbc.ca	2080-05-03
752	Maynord	Dungay	\N	752@fajna_biblioteka_2137.pl	2021-06-09
753	Lynnell	Lago	\N	753@fajna_biblioteka_2137.pl	2021-06-09
754	Elsie	Sollner	亦涵	esollnerkx@nba.com	2068-11-26
755	Lorrie	Paskin	昕磊	lpaskinky@about.me	2052-12-14
756	Carlin	Domotor	宸赫	cdomotorkz@europa.eu	2027-01-11
757	Kris	Waylen	\N	757@fajna_biblioteka_2137.pl	2021-06-09
758	Allyce	Lain	晧宇	alainl1@theglobeandmail.com	1974-10-18
759	De witt	Maxworthy	\N	759@fajna_biblioteka_2137.pl	2021-06-09
760	Paolina	Spens	\N	760@fajna_biblioteka_2137.pl	2021-06-09
761	Carmencita	McLeod	\N	761@fajna_biblioteka_2137.pl	2021-06-09
762	Robert	Buggs	\N	762@fajna_biblioteka_2137.pl	2021-06-09
763	Vonnie	Trever	静香	vtreverl6@pcworld.com	2022-03-11
764	Quinn	Lohden	孜绍	qlohdenl7@fc2.com	2022-08-06
765	Marna	Purse	\N	765@fajna_biblioteka_2137.pl	2021-06-09
766	Marget	Sheber	\N	766@fajna_biblioteka_2137.pl	2021-06-09
767	Joceline	Sevier	依娜	jsevierla@cdbaby.com	2037-10-22
768	Bari	Needs	\N	768@fajna_biblioteka_2137.pl	2021-06-09
769	Rosalynd	Oldmeadow	\N	769@fajna_biblioteka_2137.pl	2021-06-09
770	Virginia	Necolds	\N	770@fajna_biblioteka_2137.pl	2021-06-09
771	Lacie	Steptowe	\N	771@fajna_biblioteka_2137.pl	2021-06-09
772	Carena	Milington	\N	772@fajna_biblioteka_2137.pl	2021-06-09
773	Solomon	Carle	\N	773@fajna_biblioteka_2137.pl	2021-06-09
774	Pietrek	Bradden	\N	774@fajna_biblioteka_2137.pl	2021-06-09
775	Fina	Minger	\N	775@fajna_biblioteka_2137.pl	2021-06-09
776	Edyth	Magister	\N	776@fajna_biblioteka_2137.pl	2021-06-09
777	Emmit	Kenelin	\N	777@fajna_biblioteka_2137.pl	2021-06-09
778	Bryna	Odney	\N	778@fajna_biblioteka_2137.pl	2021-06-09
779	Haywood	Clemmitt	\N	779@fajna_biblioteka_2137.pl	2021-06-09
780	Davon	Caldero	\N	780@fajna_biblioteka_2137.pl	2021-06-09
781	Jeno	Eccleshall	\N	781@fajna_biblioteka_2137.pl	2021-06-09
782	Ariel	Harmour	月婵	aharmourlp@earthlink.net	1919-01-15
783	Tess	Kobu	\N	783@fajna_biblioteka_2137.pl	2021-06-09
784	Loraine	Perrone	\N	784@fajna_biblioteka_2137.pl	2021-06-09
785	Imojean	Oldrey	志宸	ioldreyls@is.gd	2087-07-28
786	Lorry	Penfold	\N	786@fajna_biblioteka_2137.pl	2021-06-09
787	Genna	Blackburn	\N	787@fajna_biblioteka_2137.pl	2021-06-09
788	Gerardo	Moehler	\N	788@fajna_biblioteka_2137.pl	2021-06-09
789	Rora	Bamblett	墨含	rbamblettlw@mozilla.org	1974-10-21
790	Cullan	Shucksmith	\N	790@fajna_biblioteka_2137.pl	2021-06-09
791	Amos	Newlove	明美	anewlovely@51.la	2079-10-02
792	Alejandrina	Belliard	\N	792@fajna_biblioteka_2137.pl	2021-06-09
793	Aidan	Belsham	\N	793@fajna_biblioteka_2137.pl	2021-06-09
794	Georgie	Meltetal	\N	794@fajna_biblioteka_2137.pl	2021-06-09
795	Haily	Campos	\N	795@fajna_biblioteka_2137.pl	2021-06-09
796	Thomasin	Kenshole	美莲	tkensholem3@4shared.com	1909-07-20
797	Pedro	Silkston	\N	797@fajna_biblioteka_2137.pl	2021-06-09
798	Adrien	Faltin	军卿	afaltinm5@vinaora.com	1987-08-13
799	Maury	Tugman	韵寒	mtugmanm6@artisteer.com	2021-07-23
800	Micheline	Bumpass	若瑾	mbumpassm7@harvard.edu	1991-11-23
801	Lorita	Jillions	烨伟	ljillionsm8@nhs.uk	1962-06-04
802	Alysa	Poleye	远帆	apoleyem9@homestead.com	2090-11-10
803	Benny	Hammel	睿杰	bhammelma@samsung.com	1961-08-04
804	Grange	Arnall	亦涵	garnallmb@amazon.com	2081-10-03
805	Ricoriki	Levington	\N	805@fajna_biblioteka_2137.pl	2021-06-09
806	Rainer	Clemont	思宇	rclemontmd@admin.ch	2001-10-19
807	Berton	Richemond	\N	807@fajna_biblioteka_2137.pl	2021-06-09
808	Tamarra	Basten	\N	808@fajna_biblioteka_2137.pl	2021-06-09
809	Stefanie	Wymer	志宸	swymermg@fc2.com	1946-08-18
810	Lora	Pleavin	雨萌	lpleavinmh@theguardian.com	2095-08-20
811	Starla	Ayres	\N	811@fajna_biblioteka_2137.pl	2021-06-09
812	Eolanda	Garrique	军卿	egarriquemj@fema.gov	2008-09-11
813	Tarrah	Egel	\N	813@fajna_biblioteka_2137.pl	2021-06-09
814	Camellia	Cookman	彦军	ccookmanml@gravatar.com	2052-09-17
815	Lazar	Scrimshaw	\N	815@fajna_biblioteka_2137.pl	2021-06-09
816	Daria	Fausch	展博	dfauschmn@cpanel.net	2036-09-23
817	Dud	Handaside	茹雪	dhandasidemo@salon.com	2078-11-28
818	Andre	Martinson	\N	818@fajna_biblioteka_2137.pl	2021-06-09
819	Andriette	Longbone	\N	819@fajna_biblioteka_2137.pl	2021-06-09
820	Bogart	Wychard	银含	bwychardmr@about.me	2062-06-23
821	Kalinda	Coughan	银涵	kcoughanms@scientificamerican.com	2049-10-06
822	Koressa	Rosekilly	伟菘	krosekillymt@berkeley.edu	2011-04-11
823	Henriette	McKeowon	瀚聪	hmckeowonmu@cbc.ca	2020-09-18
824	Haroun	Lukianov	\N	824@fajna_biblioteka_2137.pl	2021-06-09
825	Kayley	Edgell	\N	825@fajna_biblioteka_2137.pl	2021-06-09
826	Gavra	Goodinge	\N	826@fajna_biblioteka_2137.pl	2021-06-09
827	Lisetta	Bartlomiejczyk	\N	827@fajna_biblioteka_2137.pl	2021-06-09
828	Robinette	Ruddiman	\N	828@fajna_biblioteka_2137.pl	2021-06-09
829	Dexter	Musicka	\N	829@fajna_biblioteka_2137.pl	2021-06-09
830	Alexis	Zealey	\N	830@fajna_biblioteka_2137.pl	2021-06-09
831	Sergeant	Payze	秉皓	spayzen2@ucsd.edu	2018-09-27
832	Yancy	Cree	静香	ycreen3@home.pl	1916-06-02
833	Eddie	Ilson	\N	833@fajna_biblioteka_2137.pl	2021-06-09
834	Perle	Mathely	唯枫	pmathelyn5@cnet.com	1936-03-21
835	Philip	Snellman	\N	835@fajna_biblioteka_2137.pl	2021-06-09
836	Roddy	Martell	\N	836@fajna_biblioteka_2137.pl	2021-06-09
837	Archibaldo	Bikker	羽彤	abikkern8@edublogs.org	1985-04-24
838	Cad	Laux	玺越	clauxn9@nasa.gov	2071-10-30
839	Annemarie	Glanester	\N	839@fajna_biblioteka_2137.pl	2021-06-09
840	Maximilian	Boote	\N	840@fajna_biblioteka_2137.pl	2021-06-09
841	Lorine	Di Boldi	\N	841@fajna_biblioteka_2137.pl	2021-06-09
842	Winthrop	Targetter	\N	842@fajna_biblioteka_2137.pl	2021-06-09
843	Beverly	Cavil	雪丽	bcavilne@freewebs.com	2066-11-27
844	Shay	Lattka	\N	844@fajna_biblioteka_2137.pl	2021-06-09
845	Kamillah	Wauchope	浩霖	kwauchopeng@soup.io	1947-10-05
846	Cosme	Kirkebye	\N	846@fajna_biblioteka_2137.pl	2021-06-09
847	Nolana	Seeger	\N	847@fajna_biblioteka_2137.pl	2021-06-09
848	Gilbertine	Beloe	云哲	gbeloenj@amazonaws.com	1974-11-24
849	Staffard	Castagno	\N	849@fajna_biblioteka_2137.pl	2021-06-09
850	Goober	Moehle	\N	850@fajna_biblioteka_2137.pl	2021-06-09
851	Daphne	Gamon	\N	851@fajna_biblioteka_2137.pl	2021-06-09
852	Ricoriki	Ciccotti	孜绍	rciccottinn@csmonitor.com	2085-05-13
853	Denice	Bonwell	\N	853@fajna_biblioteka_2137.pl	2021-06-09
854	Rori	Kohnen	\N	854@fajna_biblioteka_2137.pl	2021-06-09
855	Wendeline	Martindale	\N	855@fajna_biblioteka_2137.pl	2021-06-09
856	Wit	Jordanson	\N	856@fajna_biblioteka_2137.pl	2021-06-09
857	Curr	Synan	宸赫	csynanns@who.int	2056-02-09
858	Anette	Audibert	月婵	aaudibertnt@ted.com	2060-10-13
859	Corny	Sherrocks	玺越	csherrocksnu@hhs.gov	2007-11-16
860	Clementius	Souter	玺越	csouternv@gnu.org	2063-07-04
861	Kenyon	Althrop	\N	861@fajna_biblioteka_2137.pl	2021-06-09
862	Mureil	Pudner	静香	mpudnernx@ucsd.edu	2059-04-07
863	Delilah	Brickwood	笑薇	dbrickwoodny@earthlink.net	2059-03-11
864	Daniella	Plackstone	\N	864@fajna_biblioteka_2137.pl	2021-06-09
865	Dre	Winger	可馨	dwingero0@ow.ly	2028-10-23
866	Gardie	Lalonde	\N	866@fajna_biblioteka_2137.pl	2021-06-09
867	Randal	Sircomb	\N	867@fajna_biblioteka_2137.pl	2021-06-09
868	Aguste	Romanski	月婵	aromanskio3@people.com.cn	1903-04-30
869	Sherwynd	Skipper	\N	869@fajna_biblioteka_2137.pl	2021-06-09
870	Lizabeth	Haysman	云哲	lhaysmano5@google.fr	1917-01-17
871	Tymothy	Wilmot	\N	871@fajna_biblioteka_2137.pl	2021-06-09
872	Benny	Impy	\N	872@fajna_biblioteka_2137.pl	2021-06-09
873	Roshelle	Solomonides	雨婷	rsolomonideso8@github.com	2063-12-24
874	Northrop	Cordeix	\N	874@fajna_biblioteka_2137.pl	2021-06-09
875	Fredia	Matteris	亦涵	fmatterisoa@sohu.com	2043-01-13
876	Morena	Middup	\N	876@fajna_biblioteka_2137.pl	2021-06-09
877	Rosemonde	Marrable	雨嘉	rmarrableoc@slashdot.org	2032-11-12
878	Berni	Denk	漫妮	bdenkod@seattletimes.com	1925-06-06
879	Marthe	Renzini	\N	879@fajna_biblioteka_2137.pl	2021-06-09
880	Maurizio	Trew	\N	880@fajna_biblioteka_2137.pl	2021-06-09
881	Gardy	Siddon	云哲	gsiddonog@spotify.com	1953-12-12
882	Jay	Chastang	\N	882@fajna_biblioteka_2137.pl	2021-06-09
883	Marinna	Lace	\N	883@fajna_biblioteka_2137.pl	2021-06-09
884	Nolan	Jeske	梦洁	njeskeoj@elpais.com	1932-12-27
885	Jori	Roon	\N	885@fajna_biblioteka_2137.pl	2021-06-09
886	Gayleen	Ivanchin	\N	886@fajna_biblioteka_2137.pl	2021-06-09
887	Roslyn	Peteri	\N	887@fajna_biblioteka_2137.pl	2021-06-09
888	Cullin	Biasio	梓彤	cbiasioon@desdev.cn	1954-11-25
889	Yancey	Monckton	奕漳	ymoncktonoo@discovery.com	2082-11-01
890	Gabriellia	Coppo	\N	890@fajna_biblioteka_2137.pl	2021-06-09
891	Pennie	Tinkler	琪煜	ptinkleroq@discovery.com	2004-11-22
892	Palm	Zipsell	浩成	pzipsellor@list-manage.com	2013-03-30
893	Freddy	Nunnery	浩霖	fnunneryos@blinklist.com	1979-06-14
894	Catriona	Rippen	\N	894@fajna_biblioteka_2137.pl	2021-06-09
895	Fawnia	Lacroutz	\N	895@fajna_biblioteka_2137.pl	2021-06-09
896	Ebeneser	Cowup	\N	896@fajna_biblioteka_2137.pl	2021-06-09
897	Consalve	Lasseter	\N	897@fajna_biblioteka_2137.pl	2021-06-09
898	Jackie	Peascod	\N	898@fajna_biblioteka_2137.pl	2021-06-09
899	Roshelle	Londing	\N	899@fajna_biblioteka_2137.pl	2021-06-09
900	Zorina	Gierhard	\N	900@fajna_biblioteka_2137.pl	2021-06-09
901	Tymon	Vivers	云哲	tviversp0@dropbox.com	2047-04-16
902	Elsey	Rawkesby	雨萌	erawkesbyp1@google.ca	2024-04-03
903	Aleece	Assur	松源	aassurp2@google.com.hk	2073-05-04
904	Natale	Engel	\N	904@fajna_biblioteka_2137.pl	2021-06-09
905	De	Haistwell	\N	905@fajna_biblioteka_2137.pl	2021-06-09
906	Oralle	Reddle	\N	906@fajna_biblioteka_2137.pl	2021-06-09
907	Mortimer	Boxhill	\N	907@fajna_biblioteka_2137.pl	2021-06-09
908	Desiri	Pull	\N	908@fajna_biblioteka_2137.pl	2021-06-09
909	Doreen	Andreaccio	\N	909@fajna_biblioteka_2137.pl	2021-06-09
910	Brandy	McGirl	婧琪	bmcgirlp9@studiopress.com	2056-09-13
911	Brit	Birley	雨萌	bbirleypa@deliciousdays.com	2057-05-19
912	Ginny	Skippon	钰彤	gskipponpb@telegraph.co.uk	2024-03-30
913	Ezmeralda	Mateo	\N	913@fajna_biblioteka_2137.pl	2021-06-09
914	Marcela	Salmond	\N	914@fajna_biblioteka_2137.pl	2021-06-09
915	Maryjane	Algy	雅芙	malgype@dion.ne.jp	2007-08-14
916	Gigi	Franey	\N	916@fajna_biblioteka_2137.pl	2021-06-09
917	Aubry	Potteridge	\N	917@fajna_biblioteka_2137.pl	2021-06-09
918	Heinrick	Gammie	丰逸	hgammieph@ycombinator.com	1959-08-09
919	Haskell	Clissell	\N	919@fajna_biblioteka_2137.pl	2021-06-09
920	Adelaide	Craven	尹智	acravenpj@admin.ch	1944-03-31
921	Silvain	Rooper	凰羽	srooperpk@delicious.com	1951-07-11
922	Jorry	Rolph	雅静	jrolphpl@jimdo.com	2066-04-14
923	Maddy	Meechan	\N	923@fajna_biblioteka_2137.pl	2021-06-09
924	Trixi	Seggie	龙胜	tseggiepn@hibu.com	2032-03-16
925	Chrisse	Faint	\N	925@fajna_biblioteka_2137.pl	2021-06-09
926	Linn	Castri	\N	926@fajna_biblioteka_2137.pl	2021-06-09
927	Myrta	Jendrich	\N	927@fajna_biblioteka_2137.pl	2021-06-09
928	Martie	Allington	\N	928@fajna_biblioteka_2137.pl	2021-06-09
929	Marielle	L' Anglois	\N	929@fajna_biblioteka_2137.pl	2021-06-09
930	Roman	Shalloe	\N	930@fajna_biblioteka_2137.pl	2021-06-09
931	Janek	Brody	丰逸	jbrodypu@adobe.com	1906-03-20
932	Georas	Salleir	\N	932@fajna_biblioteka_2137.pl	2021-06-09
933	Nikolai	McCudden	璟雯	nmccuddenpw@noaa.gov	1960-08-20
934	Silvanus	Rennock	\N	934@fajna_biblioteka_2137.pl	2021-06-09
935	Reinhold	Kesten	\N	935@fajna_biblioteka_2137.pl	2021-06-09
936	Myrle	Meert	\N	936@fajna_biblioteka_2137.pl	2021-06-09
937	Suellen	Krinks	昕磊	skrinksq0@cpanel.net	2081-10-07
938	Fidole	Krzysztofiak	墨含	fkrzysztofiakq1@cloudflare.com	1958-10-18
939	Mayne	Fellgate	俞凯	mfellgateq2@live.com	2028-11-15
940	Izzy	Chaves	\N	940@fajna_biblioteka_2137.pl	2021-06-09
941	Lindsay	Beernt	\N	941@fajna_biblioteka_2137.pl	2021-06-09
942	Arlyne	Morlon	丰逸	amorlonq5@hc360.com	1905-03-10
943	Miner	Rudge	\N	943@fajna_biblioteka_2137.pl	2021-06-09
944	Sherie	Tucknott	孜绍	stucknottq7@youku.com	2026-04-08
945	Morgen	Proswell	\N	945@fajna_biblioteka_2137.pl	2021-06-09
946	Che	Pettinger	\N	946@fajna_biblioteka_2137.pl	2021-06-09
947	Joshia	Duignan	\N	947@fajna_biblioteka_2137.pl	2021-06-09
948	Jennine	Coppock.	俊誉	jcoppockqb@gnu.org	1907-11-24
949	Witty	Durnin	\N	949@fajna_biblioteka_2137.pl	2021-06-09
950	Mona	Lesly	\N	950@fajna_biblioteka_2137.pl	2021-06-09
951	Etan	Scane	志宸	escaneqe@washington.edu	2014-07-03
952	Nicki	Monkhouse	\N	952@fajna_biblioteka_2137.pl	2021-06-09
953	Halie	Mandres	凰羽	hmandresqg@printfriendly.com	2064-09-05
954	Imogene	Hardware	婧琪	ihardwareqh@thetimes.co.uk	2043-01-24
955	Eilis	Keely	\N	955@fajna_biblioteka_2137.pl	2021-06-09
956	Aridatha	Balls	军卿	aballsqj@samsung.com	1907-11-19
957	Malynda	Ainslee	\N	957@fajna_biblioteka_2137.pl	2021-06-09
958	Lora	Dummigan	烨伟	ldummiganql@bloomberg.com	1984-12-07
959	Toby	Trenfield	\N	959@fajna_biblioteka_2137.pl	2021-06-09
960	Dulci	Fordham	剑波	dfordhamqn@census.gov	1931-12-26
961	Carmita	Lukianov	皓睿	clukianovqo@yelp.com	1966-11-28
962	Bird	Jewson	月松	bjewsonqp@cdc.gov	1973-07-16
963	Benji	Almeida	\N	963@fajna_biblioteka_2137.pl	2021-06-09
964	Stepha	Andrag	凰羽	sandragqr@privacy.gov.au	1918-09-23
965	Rolph	Collocott	睿杰	rcollocottqs@usgs.gov	1971-08-30
966	Duffy	Garza	娅楠	dgarzaqt@smh.com.au	1974-07-15
967	Ganny	Sangra	瀚聪	gsangraqu@webs.com	1951-02-18
968	Raimund	Lamborn	\N	968@fajna_biblioteka_2137.pl	2021-06-09
969	Kippar	Manneville	\N	969@fajna_biblioteka_2137.pl	2021-06-09
970	Gwynne	Meads	\N	970@fajna_biblioteka_2137.pl	2021-06-09
971	Galvan	Mapes	佐仪	gmapesqy@ameblo.jp	2008-06-15
972	Juditha	Lapwood	梓彤	jlapwoodqz@arizona.edu	2081-11-27
973	Dionne	Sidery	\N	973@fajna_biblioteka_2137.pl	2021-06-09
974	Lydie	Betancourt	\N	974@fajna_biblioteka_2137.pl	2021-06-09
975	Kaine	Edgehill	\N	975@fajna_biblioteka_2137.pl	2021-06-09
976	Ilse	Kelly	怡香	ikellyr3@photobucket.com	2072-01-10
977	Shelden	Rapkins	\N	977@fajna_biblioteka_2137.pl	2021-06-09
978	Barnebas	Crumbie	月婵	bcrumbier5@unicef.org	2021-02-25
979	Janna	Gowthrop	\N	979@fajna_biblioteka_2137.pl	2021-06-09
980	Erda	Belt	\N	980@fajna_biblioteka_2137.pl	2021-06-09
981	Retha	Jaray	\N	981@fajna_biblioteka_2137.pl	2021-06-09
982	Shirl	Reasun	香茹	sreasunr9@goo.ne.jp	2000-04-06
983	Mindy	Girauld	\N	983@fajna_biblioteka_2137.pl	2021-06-09
984	Binky	Mattholie	\N	984@fajna_biblioteka_2137.pl	2021-06-09
985	Silva	Goodyer	梓彤	sgoodyerrc@washingtonpost.com	1929-05-02
986	Bertie	Weatherill	\N	986@fajna_biblioteka_2137.pl	2021-06-09
987	Alistair	Dracey	\N	987@fajna_biblioteka_2137.pl	2021-06-09
988	Dacia	Pietzner	昕磊	dpietznerrf@yelp.com	1966-10-19
989	Johann	Cochern	彦军	jcochernrg@cocolog-nifty.com	1947-09-29
990	Aloysia	Hutchins	\N	990@fajna_biblioteka_2137.pl	2021-06-09
991	Rikki	Dowsey	俞凯	rdowseyri@loc.gov	2014-12-12
992	Joseph	Orbine	\N	992@fajna_biblioteka_2137.pl	2021-06-09
993	Wolfy	Jentges	\N	993@fajna_biblioteka_2137.pl	2021-06-09
994	Dacey	Ruslin	\N	994@fajna_biblioteka_2137.pl	2021-06-09
995	Millisent	Zini	月婵	mzinirm@dropbox.com	2058-05-18
996	August	Dallicott	\N	996@fajna_biblioteka_2137.pl	2021-06-09
997	Philippe	Morris	\N	997@fajna_biblioteka_2137.pl	2021-06-09
998	Herc	Quarmby	孜绍	hquarmbyrp@prnewswire.com	2050-05-20
999	Myrwyn	Enoksson	\N	999@fajna_biblioteka_2137.pl	2021-06-09
1000	Janet	McKinn	瀚聪	jmckinnrr@ftc.gov	2031-04-21
\.


--
-- Data for Name: czlowieki_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.czlowieki_role (czlowieki_czlowieki_id, role_id_roli) FROM stdin;
811	4
185	2
173	5
960	5
599	4
755	5
555	2
928	5
550	5
584	3
106	3
516	1
261	4
354	3
184	3
774	5
685	2
380	2
278	4
108	4
63	3
204	3
421	1
467	3
424	4
921	4
115	3
618	3
399	2
487	2
395	1
894	1
56	1
708	4
358	3
651	2
648	2
774	3
387	2
951	4
412	4
907	4
932	4
516	5
330	5
742	1
1	5
202	1
233	5
464	5
478	4
453	4
176	1
824	4
883	2
353	1
325	1
889	5
271	3
726	2
322	4
100	3
396	5
674	4
856	3
126	3
565	4
97	4
614	3
804	3
384	2
632	5
750	2
238	3
330	1
428	4
904	4
678	4
887	5
197	1
758	2
842	3
195	1
718	5
263	2
879	1
469	2
521	1
326	4
453	4
910	3
382	4
672	3
917	2
246	5
799	1
140	2
234	5
176	2
389	5
236	1
476	1
365	1
349	1
159	2
878	1
21	2
458	1
51	5
669	4
307	4
828	1
800	5
277	4
869	1
959	2
566	5
205	1
937	5
891	2
738	4
736	2
386	4
209	2
914	3
604	2
656	2
208	2
513	4
386	5
450	4
13	2
340	4
849	1
707	2
184	1
226	4
665	3
251	1
795	4
536	5
980	5
46	5
467	4
31	3
577	4
168	5
626	4
384	4
989	4
326	5
564	1
685	3
202	3
362	1
866	1
395	5
950	3
625	3
854	1
351	4
687	4
126	5
605	3
154	1
274	3
666	3
445	4
28	1
605	3
841	3
45	1
133	1
400	3
188	1
384	4
372	1
684	5
279	5
488	5
15	2
636	2
103	2
394	2
199	3
448	2
162	5
203	1
308	3
185	2
92	2
694	1
322	2
906	4
647	2
146	3
502	2
736	5
619	2
588	1
524	1
859	4
345	3
209	4
697	4
597	5
837	4
987	3
514	5
688	4
901	2
427	4
60	4
161	4
12	4
403	3
150	1
253	5
96	3
530	4
691	4
963	2
259	1
888	3
874	2
13	4
953	3
953	5
855	4
530	3
179	3
575	4
534	2
311	3
639	4
773	1
951	1
46	5
185	1
267	5
584	5
801	1
872	4
87	2
819	5
216	4
408	2
451	3
897	5
739	2
665	5
1	2
390	2
683	2
677	5
587	4
816	5
939	5
130	1
548	1
650	3
915	4
49	4
46	3
161	4
596	5
422	5
269	5
815	3
873	1
212	2
46	1
829	4
858	4
590	1
416	5
522	3
30	1
907	1
595	3
19	4
488	5
975	4
718	1
958	1
982	5
830	2
170	1
856	3
315	4
351	3
159	1
469	3
563	2
237	3
833	5
841	1
612	4
404	5
625	3
262	2
898	1
575	2
670	2
451	1
180	2
773	5
294	3
173	4
105	3
26	4
860	3
44	5
56	1
564	3
711	2
258	3
660	2
571	2
936	3
640	5
999	4
787	1
15	3
553	3
781	2
928	4
397	3
846	5
666	3
400	2
236	1
411	1
60	5
32	1
179	2
502	1
22	2
221	4
208	1
104	2
40	4
898	5
701	4
457	4
680	4
519	4
951	2
445	2
606	2
432	1
406	4
55	3
354	1
491	3
85	5
920	1
370	1
403	4
763	5
893	4
85	5
649	1
818	1
795	3
2	1
603	4
544	2
289	1
391	5
879	2
812	2
491	1
573	5
977	1
426	4
262	1
893	3
634	5
198	4
906	3
527	2
250	5
233	2
919	4
270	1
408	3
79	1
396	5
628	2
373	4
84	5
223	1
203	1
135	1
898	3
715	1
215	5
225	4
737	2
255	5
75	3
171	5
183	3
27	2
522	5
92	2
942	3
355	4
619	4
620	5
986	4
403	4
932	1
834	2
584	1
914	3
872	1
724	2
529	5
192	3
115	4
539	1
348	1
467	4
279	3
345	5
332	3
352	2
673	2
713	4
597	5
972	4
780	2
664	5
215	5
134	1
503	2
549	5
302	4
50	3
64	2
892	5
841	3
572	2
844	5
253	4
749	5
30	3
718	5
218	4
382	1
81	3
950	2
728	4
673	5
934	2
913	1
404	1
346	1
695	3
397	5
19	3
734	1
333	3
323	3
446	4
688	5
22	5
218	2
698	5
849	4
871	2
70	5
241	2
141	3
46	3
970	3
450	2
70	3
17	3
239	1
996	1
249	2
622	1
943	3
801	3
388	2
909	2
93	2
170	4
258	1
628	1
639	1
958	5
748	4
392	1
635	2
346	1
335	2
987	1
685	4
123	4
475	5
679	4
520	4
264	1
384	1
872	5
645	4
641	1
7	5
717	2
813	5
33	2
469	2
732	1
593	5
796	1
433	5
17	3
572	2
816	4
968	5
462	4
995	4
535	4
389	1
234	5
776	1
576	5
53	4
216	4
107	3
122	2
544	2
805	2
886	3
866	1
488	1
831	3
628	2
50	3
534	4
82	2
709	5
266	5
984	5
88	2
457	5
132	1
136	5
865	2
543	4
502	5
994	4
345	1
250	3
844	3
264	3
419	2
127	2
12	5
343	5
352	5
267	2
368	4
362	3
746	1
353	1
11	1
500	1
699	5
990	5
375	1
90	1
897	3
908	3
235	3
876	3
601	4
550	4
461	5
95	2
149	2
648	3
137	5
157	4
79	4
328	2
881	5
548	2
70	3
263	5
960	1
377	4
272	1
342	4
544	1
354	5
348	5
207	3
757	4
319	3
124	2
776	1
976	1
68	2
187	2
228	3
729	4
190	5
130	5
186	2
920	3
61	1
326	3
115	1
206	2
505	2
280	5
316	1
365	2
404	3
601	2
395	5
410	3
999	3
95	2
567	1
780	4
798	1
961	3
614	4
177	1
928	5
814	5
455	4
25	5
367	3
687	4
376	4
219	2
940	4
278	1
842	4
890	1
925	1
152	2
59	1
123	1
195	5
994	1
895	1
840	1
28	5
744	1
626	2
134	3
770	3
862	2
713	1
864	3
296	4
202	1
602	2
521	5
530	4
646	1
525	3
36	4
522	3
892	2
338	3
456	5
452	1
16	2
933	1
284	3
677	3
325	1
694	3
633	5
853	5
322	1
797	1
816	3
179	3
51	1
41	3
298	5
616	1
471	4
72	2
961	2
821	5
666	4
691	1
269	5
901	4
527	1
817	2
700	3
254	4
683	3
205	5
123	1
553	2
17	4
815	1
688	3
423	2
401	3
522	4
501	3
392	3
56	2
663	5
583	2
371	4
425	2
945	5
797	5
798	1
193	2
927	4
74	3
503	4
223	1
51	5
806	1
45	2
302	5
886	2
820	1
475	4
626	1
617	5
650	3
968	3
544	1
240	5
350	3
43	5
254	3
512	5
23	5
399	5
349	1
322	5
203	4
786	3
304	5
245	2
810	5
3	2
161	1
703	2
602	1
307	2
124	5
643	3
856	5
489	3
93	3
195	2
684	3
111	3
392	2
489	3
51	3
263	2
316	5
650	5
652	5
945	2
869	4
312	4
867	2
13	1
736	2
698	5
478	3
519	2
317	2
294	3
593	3
728	2
805	5
398	1
731	1
924	1
256	1
310	5
798	3
927	4
71	2
440	5
453	1
733	1
346	5
549	5
268	1
655	1
297	1
677	5
66	5
81	3
912	2
384	1
373	2
162	3
231	5
292	4
753	1
355	4
806	5
440	4
337	1
690	4
467	1
394	3
309	5
103	2
291	3
927	2
35	3
426	4
694	3
490	2
814	3
934	1
416	2
82	3
378	4
667	1
233	2
292	3
175	3
22	1
788	1
597	2
529	4
681	1
716	3
566	1
576	2
830	3
890	3
684	3
607	4
510	5
362	2
617	2
733	1
202	3
967	1
725	4
334	4
441	1
961	3
979	5
101	2
732	3
350	3
593	3
136	3
634	1
672	2
617	2
236	3
208	5
731	2
938	2
44	4
386	4
915	1
786	5
24	5
139	5
368	5
972	3
4	4
811	2
919	4
613	2
346	4
522	1
260	1
817	5
918	5
504	2
131	1
433	4
504	2
484	3
318	5
427	1
58	5
730	3
246	4
464	1
960	3
770	4
779	4
851	2
294	4
240	5
127	1
443	3
772	1
783	1
634	2
512	1
790	3
993	1
878	4
611	4
286	1
276	5
274	1
33	3
370	4
386	5
266	2
22	5
214	1
942	1
717	1
607	3
205	1
906	4
871	1
952	1
680	2
885	5
101	5
471	1
300	5
227	4
10	2
479	4
327	2
843	4
607	1
863	1
425	3
170	4
39	4
617	2
974	2
914	4
488	5
197	5
897	2
478	3
179	4
212	4
217	2
973	4
874	1
246	2
576	2
617	1
427	1
328	4
607	3
451	4
160	3
225	3
724	1
425	4
94	5
655	4
953	2
184	2
525	3
400	3
868	5
661	2
85	5
289	1
555	5
548	2
333	5
359	1
483	2
922	5
748	2
360	3
833	2
389	3
827	3
664	5
31	2
984	2
909	4
971	4
799	1
767	2
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (genre_id, genre, parent_id) FROM stdin;
69	Genres	\N
4	Anthropology	69
10	Biography	69
17	Comics	69
14	Children's	69
15	Christian	69
12	Buisness	69
29	Fantasy	69
30	Feminism	69
31	Fiction	69
7	Art	69
38	Humanities	69
39	Inspirational	69
55	Reference	69
56	Religion	69
57	Science	69
58	Science Fiction	69
60	Sequential Art	69
62	Sports and Games	69
8	Artificial Intelligence	69
49	Nonfiction	69
59	Self Help	49
6	Architecture	49
1	Academic	49
23	Design	49
25	Economics	49
51	Philosophy	49
20	Computer Science	57
61	Software	20
3	Algorithms	20
53	Programming	20
54	Programming Languages	20
63	Technical	20
22	Cyberpunk	58
24	Dystopia	58
65	Usability	23
68	Website Design	23
52	Physics	57
64	Technology	57
11	Biology	57
46	Mathematics	57
2	Algebra	46
19	Computation	46
5	Apple	12
44	Management	12
50	Personal Development	59
21	Computers	20
40	Internet	21
37	Hackers	21
9	Autobiography	10
34	Games	62
35	Gaming	62
33	Game Design	34
66	Video Games	34
13	Chess	34
16	Coding	20
41	Language	38
18	Communication	41
27	Engineering	57
26	Electrical Engineering	27
28	Entrepreneurship	12
32	Finance	25
36	Graphic Novels	60
42	Linguistics	38
43	Logic	51
45	Manga	60
47	Memoir	9
48	Neuroscience	11
67	Web	40
\.


--
-- Data for Name: publishers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishers (publisher_id, name) FROM stdin;
1	O'Reilly Media
2	A Book Apart
3	A K PETERS
4	Academic Press
5	Addison Wesley
10	Albert&Sweigart
11	Alfred A. Knopf
12	AMACOM
13	AMLbook.com
14	Apress
15	Arpaci-Dusseau Books
16	Artima
17	Atlantic Monthly Press
18	Attribution-ShareAlike License
19	Avon
20	Back Bay Books
21	Bantam
23	Bartlett Publishing
24	Basic Books
25	Berkley Trade
26	Big Machine
27	Big Nerd Ranch Guides
28	Bloomsbury (NYC)
29	Blue Hole Press
30	Blue Windmill Media
31	BPB Publications
32	Bradford Book
33	Brooks Cole
34	Cambridge University Press
35	Careermonk Publications
36	Carnegie Mellon University
37	Cartwheel Web
38	Celeritas Publishing
39	Cengage Learning
40	Center for the Study of Language and Inf
41	Chapman & Hall/CRC
42	Chelsea Green Publishing
43	Clarendon Press
44	Code Energy LLC
45	College Publications
46	Copernicus Books
47	Coriolis Group,U.S.
48	Course Technology
50	CRC Press
51	createspace
52	Createspace Independent Publishing Platform
53	Creative Commons 3.0
54	Creston Books
55	Critical Connection
56	Crown
57	Crown Business
58	Crown Publishing, NY
59	Currency
60	Current
61	Dan Bader
62	Delta
63	Dey Street Books
64	Digital Press
65	Dorset House
66	Dorset House Publishing Company, Incorporated
67	Doubleday
68	Dover Publications
69	Dymaxicon
70	Ecco
71	Edinburgh University Press
72	Effective Bookshelf
73	Elsevier Science & Technology
74	Feisty Duck Ltd
75	Feiwel & Friends
76	For Dummies
77	Franklin Beedle & Associates
78	Free Press
79	Free Software Foundation
80	Friends of ED
81	Gallery Books
82	General Systemantics Press
83	Genever Benning
84	Graphics Press
85	Green Tea Press
86	Gumroad
87	Hachette Books
88	Harper
91	Harvard Business Review Press
92	Harvard University Press
93	Houghton Mifflin Harcourt
94	Hyperink
95	IDG Books Worldwide, Inc.
96	Indianapolis
97	It Revolution Press
98	John C. Scott
99	John Murray
100	John Wiley & Sons
101	Jones & Bartlett Publishers
102	Kate Thompson
103	Knopf
104	Knopf Doubleday Publishing Group
105	Leanpub
106	Little, Brown and Company
107	Lulu
109	Machine Intelligence Research Institute
110	Maker Media, Inc
111	Manning
115	Markus Winand (2012)
116	Marshall & Brainerd
117	MCD
119	McGraw-Hill
126	Merkle Bloom LLC
127	Metropolitan Books/Henry Holt (NY)
128	Microsoft Press
129	MIT
133	Morgan Kaufmann Publishers
134	MSAC Philosophy Group
136	New Riders Publishing
137	New York University Press
138	Nmap Project
139	No Starch Press
141	Off-By-One Press
143	OR Books
148	OUP Oxford
149	Oxford University Press (UK)
150	Oxford University Press, USA
151	P&R Publishing
152	Packt Publishing
154	Pantheon
155	Paraglyph Press
156	Peachpit Press
157	Pearson
158	Pearson Prentice Hall
159	Peer-To-Peer Communications
160	Penguin
164	Plume
165	Portfolio
166	Portfolio Hardcover
167	Pragmatic Bookshelf
168	Praxis Publications Inc
169	Prentice Hall
173	Princeton Architectural Press
174	Princeton University Press
175	PublicAffairs
176	Punchy Publishing
177	Pyrenean Gold Press
179	Que Publishing
180	Random House Audio Publishing Group
181	Random House Trade Paperbacks
182	Recursive Books
183	Rockport Publishers
184	Rosenfeld Media
186	Sams Publishing
187	Scribner
188	Self
190	Simon & Schuster
192	Simple Programmer
193	SitePoint
194	Society for Industrial and Applied Mathematics (SIAM)
195	Soundlikeyourself Publishing, LLC
196	Sourcebooks
197	Spectra
198	Spektrum Akademischer Verlag
199	Springer
200	St. Martin's Griffin
201	St. Martin's Press
202	Syngress
203	Syngress Publishing
204	The MIT Press
205	The Nature of Code
208	The Pragmatic Programmers, LLC.
209	Thomas Dunne Books/St Martin's Press (NY)
210	Thomson Learning
211	Tilted Windmill Press
212	Tor Books
214	Triangle Connection LLC
215	Two Scoops Press
216	University of Chicago Press
217	University of Illinois Press
218	Verso
220	Viking Books
221	Virgin Books
222	W. H. Freeman
223	W. W. Norton Company
226	W.H. Freeman & Company
227	Walker Books
228	Waveland Pr Inc
229	Wellesley College
230	Westview Press
232	Wiley Publishing
233	Wiley-Interscience
234	William Heinemann
235	William Morrow
236	Wolfram Media
238	Wrox Press
239	Yahoo Press
240	Yaknyam Press
241	Yale University Press
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role, id_role) FROM stdin;
sprzataczka	1
bibliotekraka\\karz	2
klijent	3
bss	4
administrator	5
\.


--
-- Name: accounts_id_account_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_id_account_seq', 1, false);


--
-- Name: authors_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authors_author_id_seq', 1, false);


--
-- Name: books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_book_id_seq', 1, false);


--
-- Name: czlowieki_czlowieki_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.czlowieki_czlowieki_id_seq', 2, true);


--
-- Name: genres_genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genres_genre_id_seq', 1, false);


--
-- Name: publishers_publisher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publishers_publisher_id_seq', 1, false);


--
-- Name: roles_id_role_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_role_seq', 1, false);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id_account);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (author_id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (book_id);


--
-- Name: czlowieki czlowieki_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.czlowieki
    ADD CONSTRAINT czlowieki_pkey PRIMARY KEY (czlowieki_id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genre_id);


--
-- Name: publishers publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (publisher_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_role);


--
-- Name: czlowieki adddate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER adddate BEFORE INSERT ON public.czlowieki FOR EACH ROW EXECUTE FUNCTION public.adddate();


--
-- Name: czlowieki addemail; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER addemail BEFORE INSERT ON public.czlowieki FOR EACH ROW EXECUTE FUNCTION public.addemail();


--
-- Name: accounts accounts_czlowieki_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_czlowieki_id_fkey FOREIGN KEY (czlowieki_id) REFERENCES public.czlowieki(czlowieki_id) NOT VALID;


--
-- Name: book_authors book_authors_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(author_id) NOT VALID;


--
-- Name: book_authors book_authors_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id) NOT VALID;


--
-- Name: book_genres book_genres_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_genres
    ADD CONSTRAINT book_genres_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id) NOT VALID;


--
-- Name: book_genres book_genres_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_genres
    ADD CONSTRAINT book_genres_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(genre_id) NOT VALID;


--
-- Name: books_publishers books_publishers_books_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_publishers
    ADD CONSTRAINT books_publishers_books_book_id_fkey FOREIGN KEY (books_book_id) REFERENCES public.books(book_id) NOT VALID;


--
-- Name: books_publishers books_publishers_publishers_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_publishers
    ADD CONSTRAINT books_publishers_publishers_publisher_id_fkey FOREIGN KEY (publishers_publisher_id) REFERENCES public.publishers(publisher_id) NOT VALID;


--
-- Name: borrowed borrowed_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowed
    ADD CONSTRAINT borrowed_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id) NOT VALID;


--
-- Name: borrowed borrowed_czlowieki_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowed
    ADD CONSTRAINT borrowed_czlowieki_id_fkey FOREIGN KEY (czlowieki_id) REFERENCES public.czlowieki(czlowieki_id) NOT VALID;


--
-- Name: czlowieki_role czlowieki_role_czlowieki_czlowieki_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.czlowieki_role
    ADD CONSTRAINT czlowieki_role_czlowieki_czlowieki_id_fkey FOREIGN KEY (czlowieki_czlowieki_id) REFERENCES public.czlowieki(czlowieki_id) NOT VALID;


--
-- Name: czlowieki_role czlowieki_role_role_id_roli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.czlowieki_role
    ADD CONSTRAINT czlowieki_role_role_id_roli_fkey FOREIGN KEY (role_id_roli) REFERENCES public.roles(id_role) NOT VALID;


--
-- Name: genres genres_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.genres(genre_id) NOT VALID;


--
-- PostgreSQL database dump complete
--

