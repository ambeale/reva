--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: dishes; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.dishes (
    dish_id integer NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.dishes OWNER TO vagrant;

--
-- Name: dishes_dish_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.dishes_dish_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dishes_dish_id_seq OWNER TO vagrant;

--
-- Name: dishes_dish_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.dishes_dish_id_seq OWNED BY public.dishes.dish_id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.favorites (
    favorite_id integer NOT NULL,
    user_id integer,
    restaurant_id character varying(200)
);


ALTER TABLE public.favorites OWNER TO vagrant;

--
-- Name: favorites_favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.favorites_favorite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.favorites_favorite_id_seq OWNER TO vagrant;

--
-- Name: favorites_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.favorites_favorite_id_seq OWNED BY public.favorites.favorite_id;


--
-- Name: restaurant_dishes; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.restaurant_dishes (
    restaurant_dish_id integer NOT NULL,
    dish_id integer,
    restaurant_id character varying(200)
);


ALTER TABLE public.restaurant_dishes OWNER TO vagrant;

--
-- Name: restaurant_dishes_restaurant_dish_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.restaurant_dishes_restaurant_dish_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restaurant_dishes_restaurant_dish_id_seq OWNER TO vagrant;

--
-- Name: restaurant_dishes_restaurant_dish_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.restaurant_dishes_restaurant_dish_id_seq OWNED BY public.restaurant_dishes.restaurant_dish_id;


--
-- Name: restaurants; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.restaurants (
    restaurant_id character varying(200) NOT NULL,
    name character varying(200),
    phone_number character varying(20),
    address character varying(200),
    website character varying(200),
    lat numeric,
    lon numeric
);


ALTER TABLE public.restaurants OWNER TO vagrant;

--
-- Name: review_dishes; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.review_dishes (
    review_dish_id integer NOT NULL,
    dish_id integer,
    review_id integer,
    dish_comment text
);


ALTER TABLE public.review_dishes OWNER TO vagrant;

--
-- Name: review_dishes_review_dish_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.review_dishes_review_dish_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.review_dishes_review_dish_id_seq OWNER TO vagrant;

--
-- Name: review_dishes_review_dish_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.review_dishes_review_dish_id_seq OWNED BY public.review_dishes.review_dish_id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    user_id integer,
    restaurant_id character varying(200),
    created_at timestamp without time zone NOT NULL,
    food_score integer NOT NULL,
    food_comment text,
    service_score integer NOT NULL,
    service_comment text,
    price_score integer NOT NULL,
    price_comment text
);


ALTER TABLE public.reviews OWNER TO vagrant;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.reviews_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_review_id_seq OWNER TO vagrant;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vagrant
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(64) NOT NULL,
    fname character varying(64) NOT NULL,
    lname character varying(64) NOT NULL,
    password character varying(64) NOT NULL,
    zipcode character varying(15),
    icon character varying(300) NOT NULL
);


ALTER TABLE public.users OWNER TO vagrant;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO vagrant;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: dish_id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.dishes ALTER COLUMN dish_id SET DEFAULT nextval('public.dishes_dish_id_seq'::regclass);


--
-- Name: favorite_id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.favorites ALTER COLUMN favorite_id SET DEFAULT nextval('public.favorites_favorite_id_seq'::regclass);


--
-- Name: restaurant_dish_id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.restaurant_dishes ALTER COLUMN restaurant_dish_id SET DEFAULT nextval('public.restaurant_dishes_restaurant_dish_id_seq'::regclass);


--
-- Name: review_dish_id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.review_dishes ALTER COLUMN review_dish_id SET DEFAULT nextval('public.review_dishes_review_dish_id_seq'::regclass);


--
-- Name: review_id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: dishes; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.dishes (dish_id, name) FROM stdin;
1	Tea-Smoked Garlic Chicken
2	Fire-Roasted Pepper & Mango Lamb
3	Roasted Beets & Orange Tuna
4	Pickled Sugar Pasta
5	Pan-Fried Confit of Rice
6	Gentle-Fried Blueberry & Mushroom Taco
7	Melon and Cranberry Jam
8	Mandarin and Banana Toast
9	Kiwi Whip
10	Lime Pastry
\.


--
-- Name: dishes_dish_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.dishes_dish_id_seq', 10, true);


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.favorites (favorite_id, user_id, restaurant_id) FROM stdin;
\.


--
-- Name: favorites_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.favorites_favorite_id_seq', 1, false);


--
-- Data for Name: restaurant_dishes; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.restaurant_dishes (restaurant_dish_id, dish_id, restaurant_id) FROM stdin;
1	1	ChIJlfC_eYKAhYARhcWC559q0jc
2	1	ChIJMygdeCZ-j4ARKDtpQiICwUo
3	1	ChIJfcaly4eAhYARSIvvfFpH64w
4	1	ChIJVRnYLHyAhYARhl2ZVJFi5iU
5	1	ChIJfcaly4eAhYARSIvvfFpH64w
6	1	ChIJfcaly4eAhYARSIvvfFpH64w
7	1	ChIJNZloNTd-j4ARxGMOXZp7KfI
8	1	ChIJNZloNTd-j4ARxGMOXZp7KfI
9	1	ChIJh_24QJ-AhYAR_xbUNVN2Xns
10	1	ChIJKT_dq7GAhYARpHV3vs0HUWQ
11	2	ChIJMygdeCZ-j4ARKDtpQiICwUo
12	2	ChIJzf0lTbCAhYARqz-tqaIyJaY
13	2	ChIJh_24QJ-AhYAR_xbUNVN2Xns
14	2	ChIJMygdeCZ-j4ARKDtpQiICwUo
15	2	ChIJk8dm4J6AhYAR8MCM6inxTgE
16	2	ChIJk8dm4J6AhYAR8MCM6inxTgE
17	2	ChIJlfC_eYKAhYARhcWC559q0jc
18	2	ChIJzf0lTbCAhYARqz-tqaIyJaY
19	2	ChIJfcaly4eAhYARSIvvfFpH64w
20	2	ChIJNZloNTd-j4ARxGMOXZp7KfI
21	3	ChIJNZloNTd-j4ARxGMOXZp7KfI
22	3	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
23	3	ChIJfcaly4eAhYARSIvvfFpH64w
24	3	ChIJk8dm4J6AhYAR8MCM6inxTgE
25	3	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
26	3	ChIJVRnYLHyAhYARhl2ZVJFi5iU
27	3	ChIJk8dm4J6AhYAR8MCM6inxTgE
28	3	ChIJzf0lTbCAhYARqz-tqaIyJaY
29	3	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
30	3	ChIJVRnYLHyAhYARhl2ZVJFi5iU
31	4	ChIJlfC_eYKAhYARhcWC559q0jc
32	4	ChIJfcaly4eAhYARSIvvfFpH64w
33	4	ChIJVRnYLHyAhYARhl2ZVJFi5iU
34	4	ChIJNZloNTd-j4ARxGMOXZp7KfI
35	4	ChIJMygdeCZ-j4ARKDtpQiICwUo
36	4	ChIJzf0lTbCAhYARqz-tqaIyJaY
37	4	ChIJMygdeCZ-j4ARKDtpQiICwUo
38	4	ChIJVRnYLHyAhYARhl2ZVJFi5iU
39	4	ChIJk8dm4J6AhYAR8MCM6inxTgE
40	4	ChIJKT_dq7GAhYARpHV3vs0HUWQ
41	5	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
42	5	ChIJVRnYLHyAhYARhl2ZVJFi5iU
43	5	ChIJk8dm4J6AhYAR8MCM6inxTgE
44	5	ChIJk8dm4J6AhYAR8MCM6inxTgE
45	5	ChIJKT_dq7GAhYARpHV3vs0HUWQ
46	5	ChIJlfC_eYKAhYARhcWC559q0jc
47	5	ChIJlfC_eYKAhYARhcWC559q0jc
48	5	ChIJfcaly4eAhYARSIvvfFpH64w
49	5	ChIJk8dm4J6AhYAR8MCM6inxTgE
50	5	ChIJVRnYLHyAhYARhl2ZVJFi5iU
51	6	ChIJKT_dq7GAhYARpHV3vs0HUWQ
52	6	ChIJzf0lTbCAhYARqz-tqaIyJaY
53	6	ChIJVRnYLHyAhYARhl2ZVJFi5iU
54	6	ChIJKT_dq7GAhYARpHV3vs0HUWQ
55	6	ChIJVRnYLHyAhYARhl2ZVJFi5iU
56	6	ChIJVRnYLHyAhYARhl2ZVJFi5iU
57	6	ChIJfcaly4eAhYARSIvvfFpH64w
58	6	ChIJk8dm4J6AhYAR8MCM6inxTgE
59	6	ChIJk8dm4J6AhYAR8MCM6inxTgE
60	6	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
61	7	ChIJfcaly4eAhYARSIvvfFpH64w
62	7	ChIJMygdeCZ-j4ARKDtpQiICwUo
63	7	ChIJk8dm4J6AhYAR8MCM6inxTgE
64	7	ChIJh_24QJ-AhYAR_xbUNVN2Xns
65	7	ChIJzf0lTbCAhYARqz-tqaIyJaY
66	7	ChIJh_24QJ-AhYAR_xbUNVN2Xns
67	7	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
68	7	ChIJzf0lTbCAhYARqz-tqaIyJaY
69	7	ChIJKT_dq7GAhYARpHV3vs0HUWQ
70	7	ChIJVRnYLHyAhYARhl2ZVJFi5iU
71	8	ChIJVRnYLHyAhYARhl2ZVJFi5iU
72	8	ChIJh_24QJ-AhYAR_xbUNVN2Xns
73	8	ChIJh_24QJ-AhYAR_xbUNVN2Xns
74	8	ChIJKT_dq7GAhYARpHV3vs0HUWQ
75	8	ChIJNZloNTd-j4ARxGMOXZp7KfI
76	8	ChIJlfC_eYKAhYARhcWC559q0jc
77	8	ChIJMygdeCZ-j4ARKDtpQiICwUo
78	8	ChIJzf0lTbCAhYARqz-tqaIyJaY
79	8	ChIJNZloNTd-j4ARxGMOXZp7KfI
80	8	ChIJfcaly4eAhYARSIvvfFpH64w
81	9	ChIJk8dm4J6AhYAR8MCM6inxTgE
82	9	ChIJMygdeCZ-j4ARKDtpQiICwUo
83	9	ChIJMygdeCZ-j4ARKDtpQiICwUo
84	9	ChIJh_24QJ-AhYAR_xbUNVN2Xns
85	9	ChIJNZloNTd-j4ARxGMOXZp7KfI
86	9	ChIJzf0lTbCAhYARqz-tqaIyJaY
87	9	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
88	9	ChIJzf0lTbCAhYARqz-tqaIyJaY
89	9	ChIJh_24QJ-AhYAR_xbUNVN2Xns
90	9	ChIJlfC_eYKAhYARhcWC559q0jc
91	10	ChIJzf0lTbCAhYARqz-tqaIyJaY
92	10	ChIJVRnYLHyAhYARhl2ZVJFi5iU
93	10	ChIJh_24QJ-AhYAR_xbUNVN2Xns
94	10	ChIJzf0lTbCAhYARqz-tqaIyJaY
95	10	ChIJMygdeCZ-j4ARKDtpQiICwUo
96	10	ChIJzf0lTbCAhYARqz-tqaIyJaY
97	10	ChIJzf0lTbCAhYARqz-tqaIyJaY
98	10	ChIJ5UiqQJCAhYAR5L5rAgjuf_0
99	10	ChIJzf0lTbCAhYARqz-tqaIyJaY
100	10	ChIJNZloNTd-j4ARxGMOXZp7KfI
\.


--
-- Name: restaurant_dishes_restaurant_dish_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.restaurant_dishes_restaurant_dish_id_seq', 100, true);


--
-- Data for Name: restaurants; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.restaurants (restaurant_id, name, phone_number, address, website, lat, lon) FROM stdin;
ChIJNZloNTd-j4ARxGMOXZp7KfI	Farmhouse Kitchen Thai Cuisine	(415) 814-2920	710 Florida St, San Francisco, CA 94110, USA	http://www.farmhousesf.com/	37.7602175	-122.4112856
ChIJfcaly4eAhYARSIvvfFpH64w	Tropisueño	(415) 243-0299	75 Yerba Buena Ln, San Francisco, CA 94103, USA	http://www.tropisueno.com/	37.7853583	-122.40405
ChIJlfC_eYKAhYARhcWC559q0jc	Basil	(415) 552-8999	1175 Folsom St, San Francisco, CA 94103, USA	http://www.basilthai.com/	37.7753954	-122.4092871
ChIJVRnYLHyAhYARhl2ZVJFi5iU	Osha Thai Restaurant and Lounge	(415) 896-6742	311 3rd St, San Francisco, CA 94107, USA	http://www.oshathai.com/third-street	37.783654	-122.398461
ChIJ5UiqQJCAhYAR5L5rAgjuf_0	Tadu Ethiopian Kitchen	(415) 409-6649	484 Ellis St, San Francisco, CA 94102, USA	http://taduethiopiankitchen.com/	37.7847934	-122.4141884
ChIJKT_dq7GAhYARpHV3vs0HUWQ	Oasis Cafe	(415) 474-4900	901 Divisadero St, San Francisco, CA 94115, USA	http://www.oasiscafesf.com/	37.77787800000001	-122.4385472
ChIJMygdeCZ-j4ARKDtpQiICwUo	Pink Onion	(415) 529-2635	64 14th St, San Francisco, CA 94103, USA	https://www.pinkonionmenu.com/	37.76876980000001	-122.4148819
ChIJzf0lTbCAhYARqz-tqaIyJaY	Little Star Pizza	(415) 441-1118	846 Divisadero St, San Francisco, CA 94117, USA	http://www.littlestarpizza.com/divisadero	37.77753630000001	-122.43809
ChIJh_24QJ-AhYAR_xbUNVN2Xns	Rich Table	(415) 355-9085	199 Gough St, San Francisco, CA 94102, USA	http://richtablesf.com/	37.7748683	-122.422826
ChIJk8dm4J6AhYAR8MCM6inxTgE	RT Rotisserie	\N	101 Oak St, San Francisco, CA 94102, USA	http://rtrotisserie.com/	37.7750997	-122.4210907
\.


--
-- Data for Name: review_dishes; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.review_dishes (review_dish_id, dish_id, review_id, dish_comment) FROM stdin;
1	1	74	Fire management something generation you similar issue after. Information visit window last grow. Cup factor amount short can the billion. What line care environmental cost tonight leave.
2	1	47	Have guess loss left environmental table can. Feel attack make support effect actually.
3	1	41	Art look national affect leg.
4	1	15	Close seat sing recently special air. After argue establish act deal among. Grow memory be away site.
5	1	99	Impact risk son. Yourself service picture simple appear lead. Least age between daughter decide couple letter.
6	1	98	Long southern keep role. Morning wonder option color ten act. Staff four movement president man.
7	1	51	Daughter defense southern represent recent. School exactly voice. Here food treat involve she.
8	1	41	Of official detail camera TV true. Away opportunity language well add hotel real. Fear blue a candidate miss continue.
9	1	35	Sport whether baby read nor right. Imagine data glass budget election military measure.
10	1	31	Individual soon act. Together month sell bill.
11	2	75	Trade everybody organization management maintain new. Garden interest collection response.
12	2	5	Test sit the wide. Career respond after war. State any move protect we debate color parent. Doctor type toward bring by east.
13	2	69	Whom hot poor morning should stop. Cultural never coach.
14	2	95	Can wall be citizen. Feeling career around city level degree. Out TV expert ability.
15	2	45	Guy including reality. Teacher party everyone small short interesting sea south.
16	2	51	Back bag rule car window through blue law. Despite score nearly medical western food affect. Seven prove wrong. Clearly product first budget have paper then large.
17	2	40	Last gun past Democrat attack fire he.
18	2	10	Maintain six international. Attorney fine law explain side.
19	2	24	Assume seem describe. With my reach only never of.
20	2	8	That expect party practice. Consider audience pretty cut. Happen arrive film heart child.
21	3	62	All resource front class game mention must.
22	3	10	Less street never Congress structure number. Form buy may street home race. Goal so care indeed medical hit couple.
23	3	65	Item onto only return go parent. Institution hear above. Particularly low doctor space market.
24	3	3	By campaign to music. Idea information mother quickly protect.
25	3	61	Free student poor college campaign.
26	3	61	Stuff situation young someone. City much film rich serve while Mrs walk.
27	3	21	Make senior color car quite speak. Season crime consider game business seat become toward.
28	3	39	Partner true improve quickly take. Order eight within this yes well. Number hour free.
29	3	11	Fund ever serious total able job. Likely up individual cell later article draw at.
30	3	91	Woman land book career while upon determine. Girl add ten truth green clearly dog. Discuss than series future certainly role century their. Financial hand wide store now entire recently Democrat.
31	4	87	Suffer measure table of. Memory worker nothing than official affect before.
32	4	66	Under type network most receive source public. Share start eight easy.
33	4	17	Some thus his everything. Memory huge night blue. Ability member character whatever including ask different.
34	4	83	Sign create between good. Imagine community account military type at.
35	4	8	Relationship here onto program. Effort fight so. Develop nice break officer.
36	4	76	Pattern key policy three. Clearly serve throw rich father. Particular yourself early teach point focus situation.
37	4	23	Environment language whom each clearly. Reach significant finally plan. Rich late rather focus.
38	4	85	North once audience including boy forward. Recently organization interview teacher hospital far space. Month beat who bill prove court fund.
39	4	44	Happy recent read have suffer site. Light set least great begin past lot. Expert professor toward nice act star.
40	4	81	Present popular leg factor cause few.
41	5	37	Effort available participant assume image. Both race dinner information within since. Ago attack truth almost.
42	5	11	Discover source unit site. Bit guess join ago else.
43	5	6	Material benefit newspaper although commercial. Meet politics similar before.
44	5	93	Word free prove something here space. His in house lose human shake partner. Walk attention us true watch face.
45	5	19	Sometimes value left end positive. Nothing generation position society notice down.
46	5	55	Space government reveal measure wonder. Exist senior purpose group.
47	5	11	Piece any system star. Agent service trial man entire information quality risk.
48	5	41	Evening food threat hand price reduce major morning. Then factor themselves three. Wrong him some.
49	5	45	Manager property design inside general none. Stock read pull suggest. Fact player program population sport listen large result.
50	5	56	Create let soon boy point treat. Special agree southern box send theory.
51	6	14	Agent drug stock office chair chance eight. Any yeah particularly more yes ask television subject.
52	6	80	Go dream travel store. Chance beyond east card here effect.
53	6	58	Lawyer early certain debate always stock some off. Best fund begin yeah voice work.
54	6	54	Step agent defense tonight better debate. Since produce control difficult recent. Mean game especially recognize easy within heavy four.
55	6	51	Early old candidate also thank product role. Behavior every after particularly.
56	6	61	Station focus second somebody town. Themselves agency voice fly less.
57	6	17	Adult trade write employee may responsibility wrong. Live value hair represent role. Role left all wait its many.
58	6	12	Lot win because. Attack general available school. Take base public even. Character war nice all account know scientist sport.
59	6	4	Form everybody eye because describe store likely. Put provide total hair. Keep truth almost toward owner investment. Style throw finish.
60	6	54	Animal interview eye. Keep season structure by me trouble one.
61	7	15	Commercial kid score work. Either eye bag truth Mrs court. Hand lead others present music accept.
62	7	58	Whole call thank card almost end. Forward me word consider prevent.
63	7	85	Require seem force home either always skin. Prepare might its close else then different. Here life great college picture. Interview play employee remain recognize.
64	7	40	Wait example be plant since door statement.
65	7	93	Lay good can bad also election cut. Chance stop action. Area participant eat include.
66	7	25	After no begin account light.
67	7	71	Economic number agree now physical article.
68	7	32	Run our happen baby student appear. Environmental field free goal rule popular listen now. Always blood decision.
69	7	50	Over whole group thank.
70	7	10	Course him you hospital natural. Color really house thank need house.
71	8	7	Woman tonight behavior toward. Decision face box contain officer. Heavy huge fast morning subject modern two.
72	8	47	Myself international job. Mouth themselves billion teach. Short security radio different draw none.
73	8	25	Big know animal box test line recently. Become commercial center key social sort.
74	8	81	Low line join range. Piece store box. Significant special marriage accept almost.
75	8	59	Reach seven century available decision. Easy law of financial.
76	8	3	Discussion six by ok young condition. Finish decade benefit second.
77	8	77	Capital wait part college allow positive. Think central attention want knowledge site.
78	8	52	Son we school also goal how. Eye worker fast protect piece.
79	8	34	Yard alone we later address. Gun dog surface.
80	8	13	Level character agency fund region thought. Specific leader after and strategy point control. Plant fall nature surface.
81	9	10	Building crime very always voice return central. Recognize way age dark cost how.
82	9	63	Sea color it over then less. Degree compare some establish money guess total.
83	9	7	Describe maintain life. Leave executive this hope arm Mr onto.
84	9	61	Above after me. Respond drop day suggest.
85	9	25	Ever receive box information fish research drop. Collection point forget difference myself discuss indicate behind.
86	9	52	Measure start enough agency at artist us. Fast trial tax worker probably sense toward. According my matter office production to east.
87	9	33	Allow measure affect. How difference interest study court own food my. Little along interesting trouble.
88	9	90	However nature us seem either left late. Check least wall Democrat step.
89	9	93	Anything team performance buy nor tough only. Dinner factor about nature.
90	9	26	Health bit film trade. Town window any trip door. Woman within market across receive baby.
91	10	12	By heavy body develop night. Return spend movement rest ahead any plant. Level head season nation section.
92	10	70	Ago seat reflect learn teacher attention thus chair. Behind politics herself open campaign themselves. Difficult responsibility reduce fire quite big. Already next effort mean political phone lead.
93	10	7	Tend business rate beat care subject nearly compare. Civil catch official experience factor.
94	10	73	Safe list his real tell describe other face. Drive morning former development already question energy actually. Ahead training become economic language behind spring.
95	10	73	Choose development director nice sing. Head guess Congress. High cover nor describe understand bring.
96	10	95	Anyone relate serve summer himself agency budget. Represent once board.
97	10	67	Nice local meet special apply seat. Artist a recent last animal determine.
98	10	14	Vote science specific. Finish energy none market argue fire. Cut develop great lose method artist ground.
99	10	94	Amount option give agency check. First power argue. Still early capital town.
100	10	88	Seek soon clearly young car doctor. Successful there commercial write conference.
\.


--
-- Name: review_dishes_review_dish_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.review_dishes_review_dish_id_seq', 100, true);


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.reviews (review_id, user_id, restaurant_id, created_at, food_score, food_comment, service_score, service_comment, price_score, price_comment) FROM stdin;
1	1	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.015456	3	Real shoulder office future. At letter produce make cut moment yard according. Fast out tree area group wear consider.	4	Law rule production. At set civil. Wear such mother while his.	3	According simply home positive. Practice between different service suffer city serve.
2	1	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.018477	2	Very current national research arm hundred be. Toward produce visit your professional. Check fly firm.	1	Thus chance discuss significant exist beautiful mouth culture. Final child goal natural baby.	1	Around trade girl. Put child them above investment.
3	1	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.022872	3	Every onto above until room difference stand. Rather chair then gun forward fear increase skin.	4	Thank or relationship. Rather personal business drive character long benefit. Mrs more shoulder pick alone research hot rather.	3	Father build right feeling military station about.
4	1	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.024614	4	Course local last lay watch. North place area business.	2	Thing home power. Black letter at manager strong one example. Billion while top treat must.	3	Real democratic reduce cost defense sign speech. Discussion rate husband life. Help both hope tax. President probably sound development adult study.
5	1	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.026624	5	Peace actually buy although explain keep radio. Entire like military production risk.	4	In toward whose always speech. Foot beyond hope manage product much TV. Or difficult rather guess oil appear tonight.	4	Concern must nation. Bit firm where become. Significant nature easy analysis.
6	1	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.028563	1	Know action president as personal.	1	Building phone leg teacher safe book always often. Range prove exist result month. Together Mr stuff can really dog.	1	Place continue decide western. Value guess just make town Mrs she parent. Town information available knowledge.
7	1	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.030303	1	Peace little grow quickly bar open occur. Partner husband great service eat.	3	Mention big production tax author open. List group agreement. Eight gun deep apply election.	2	Fine must charge increase theory place fly. Practice Democrat choose knowledge actually evidence cup who. Draw ball bill nation other.
8	1	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.031795	4	Various although news that article establish. Condition thing standard good loss young.	4	Try interest build. Night situation least this safe north. Catch he mean example claim top.	2	Protect seat front occur election. Training material commercial man. Eye leave ten change better buy despite show.
9	1	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.033722	2	Race win just today but. Admit common likely last himself thing.	5	Training move someone produce recognize process couple. Effect four rise dark. Large hold TV high suffer. Head himself foreign head.	2	More event accept discover.
10	1	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.035419	3	Enough Mr collection out environment eye paper. Whom allow sell degree teach question space choose. Also account soon two behavior mother manage.	5	Blue available anyone total affect. Her boy address recent strategy page.	3	Movement reality almost partner say.
11	2	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.037177	5	No of show. Would arm computer hot fight hard us lawyer.	4	Choose situation tell put particular eat. Listen near southern bank job ready. Heavy talk word fact. Politics evidence trial quickly within help year.	3	Become today civil leader cut skill. Outside top policy rate. Peace friend local wish.
12	2	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.038827	2	Affect account rate suddenly learn pretty. Rather wait black energy over no. News growth the create development anyone.	3	Little cause reach long just claim difficult. Debate section indeed peace once fund marriage.	1	Strong wrong management once. Ahead guy early whether. A impact that can answer.
13	2	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.040852	4	President open reflect concern. Participant soldier administration cup.	1	Forget the week form rich information including need. Experience such nothing reflect main expert.	5	Write bit protect. Material building family suffer should public.
14	2	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.043169	1	Nothing management tend democratic capital hot. Science either buy professor. Generation hair serve win light. Plan yes whom ability customer.	4	Several oil way. Point husband rich her.	2	Garden popular nor southern population chair. Piece actually a look of bit.
15	2	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.045004	4	Level address country test baby. Can capital bad include out.	3	Staff resource bring same different past possible. Say Mr air dinner.	3	Probably blue wife certain. Morning religious play three.
16	2	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.046666	1	Mind Congress thus physical. You really leave million war subject.	1	Above later cut spring treatment scene look. Ahead Mrs into executive program drug second senior.	2	Force safe lawyer water around similar. Executive measure member clear.
17	2	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.048484	5	Scene really itself recent. Argue employee campaign walk. South tough total attorney read.	1	Certain which poor but able.	5	Young program arm send career account science feel. Enter tree sport power say.
18	2	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.051498	4	Outside full ahead goal type whose into fund. Big while ago page hear station full.	3	Base leader Mr prove far. Kind soldier technology finally scientist community kitchen. Career son air fine.	1	This worry third and. Common follow involve site boy.
19	2	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.054125	5	Soon direction reach source why. House current give likely might couple bed strong. Response a score minute.	2	Time establish reduce.	4	Account sort alone everything its region respond. At point personal money. Evening positive stay receive dog know.
20	2	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.057078	5	I many my receive take exactly. Sport understand not long represent natural perhaps. Responsibility sit husband discuss true institution.	3	Eat oil as conference we fire. Others same ability heart successful.	3	All point third travel million address. Relate everything accept case man fear condition. Onto space program knowledge main help.
21	3	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.058626	1	Garden strategy street war these account. Likely visit song whom condition always.	1	Me unit past miss space participant. Firm firm record throw box. Ready discussion table put list range believe benefit.	2	Conference body last collection city responsibility force side. Upon various possible seven mother once. Task east deal election expect.
22	3	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.060524	4	Table manage become then early matter quickly.	5	Her structure air. Matter newspaper trip arrive mission. Again teach official same ask reflect every meeting.	4	Item author think purpose American painting medical. Firm it meeting anyone tax require than.
23	3	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.062384	1	Debate grow through population company staff discuss.	1	She leader note impact financial five woman. Avoid close four either ok remember. Speak particular man.	3	Someone example out system certain. Home third cultural real show trip someone. Nature the high senior stuff.
24	3	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.064079	1	Serve bring plan hard up. Total whatever life bed toward. After need appear interview.	4	History others per serious so begin attention. Mean sport much forward. Also much any public edge three.	1	Training edge sort notice space fish. Able read series since employee Congress.
25	3	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.065831	3	End great that commercial lead.	3	Nation success tough also generation break car. Fire forward media decide provide.	1	Team middle future what positive begin husband.
26	3	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.067739	3	Education either region else service. Side data return carry public best fight. Sense street catch hundred.	1	Enough else spend against. Ok answer carry matter front letter beat.	4	Option performance unit beyond. Want around make street rule although manage. Project remain medical wait explain.
27	3	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.06929	4	Report report relate foot. Serious dinner wind again. Might again central through eye time financial at.	4	Degree newspaper picture operation. Lose know relationship top sing head last. At action see same product.	4	Instead gas sport share school early which. Religious deal three defense everybody size. Senior according great water realize.
28	3	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.071171	1	Always child wonder raise more nor. Study tough would beat everything also.	3	Yourself key dinner threat. Safe back close concern owner. Real behavior college true.	5	Series total force air feeling Mr support. Place travel very middle decide save. Price player safe beyond front large.
29	3	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.072927	4	Serious policy grow piece plan officer. Baby power record message tell.	4	Cell drop religious machine. Beat weight turn more attention position together.	1	Sure onto where develop short garden. Course various interest successful next through. Best few chance seven deep event customer.
30	3	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.074794	4	Cut full generation mention where sound. Key one station.	5	Stock develop government government level color. Goal guess yard early.	5	Individual bank style future act meet feeling. Think seven reveal lose method.
31	4	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.07638	1	Tell responsibility many at method various fact pass. Key owner rate within easy stop. Would tree American inside consider simple other.	3	Night within blue third check. Best onto as one military environmental energy. Wrong debate while hotel. Material determine a maintain morning whom.	5	Sea street tend still play thank particularly. Them gun herself practice compare.
32	4	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.078227	3	There American that. Room camera television. Reflect perform player page maintain upon company. Area alone budget lot discuss window process foreign.	2	Wrong herself money player serve yeah. Amount themselves believe reach. Have air yes raise.	5	Pay save describe. Test enjoy box whatever from. His boy receive firm animal take maybe.
33	4	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.080126	3	Amount doctor open very seven. At quickly ready country road face former high. State no article.	2	Our send plan dog property there position voice. Woman local another top almost.	4	Administration believe message cover wonder million star. Dark plan mouth evening central none way. Lot tell forward appear his.
34	4	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.082142	5	Smile purpose college make try yeah paper daughter. Executive scene tell watch onto defense record. Read same international move believe.	1	Final yet everyone we win suddenly. What heavy radio add be. Our support action know.	2	Kid help reach establish. Center capital power.
35	4	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.083927	5	Easy address idea view bed. Election plant indeed Democrat hotel piece.	1	Later miss teacher team tough pull arm. Let life south at. Ago start issue produce education alone indicate.	4	Four wife understand player trade learn. Down our unit check.
36	4	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.086391	1	Near face heavy region focus would. Mean to structure.	5	Year personal manager. Read Democrat only population. Point guy same research.	3	Throughout father our dog chair. Rock decide factor wait you sort commercial fast.
37	4	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.088235	5	Service particular article significant speech near source. Pull probably enjoy you price rich.	5	Common stay a drive indicate. Game decade start break statement keep ground.	1	Threat then million TV build believe situation. His organization happen myself best.
38	4	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.090028	3	Arm machine light item miss. Data much career adult away suddenly. Spring six movie. Media structure hundred your friend weight.	3	Side room the across office. High trial time eye. Difference research religious article.	2	Expert happen news focus. Reality itself federal section.
39	4	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.091938	4	Site ask create. Glass probably together future professional customer. Community stop quality air but.	4	But another measure detail president several treatment. Successful country still. Huge policy read behind southern no theory event. Operation idea similar leader.	4	Place serious answer.
40	4	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.095003	3	Wear plant find plan prove pretty. Window door hundred election.	1	Manager heavy since guess. Dark rise majority green wind big. Itself she several wonder scene nice. Give let PM fight marriage fall my.	2	Where serious learn project thus. Current game your institution already pressure first result.
41	5	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.096684	5	Operation environmental as this. Official adult effort involve next young couple.	5	According do seven. Exactly cell allow.	5	Treatment system member good room. Continue effort employee middle tend cup upon.
42	5	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.098219	5	Bit camera great black. Lose you just my. Good end attorney care body wide. Environmental fall vote head have if.	3	Head safe main month computer peace back. See ground need letter course environmental skin.	4	Smile goal dog deep month bag argue light. Order way position great machine.
43	5	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.100304	4	Drug agree degree anyone. Control break affect day develop.	3	Who watch agreement participant five because.	4	Individual possible join she might perform. Stuff medical beat painting.
44	5	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.102381	4	Avoid general house project follow help. Prepare eight agent respond. Remember avoid choice six food top.	4	Work fact two. Someone for public push our really.	3	We away medical future. Congress oil call street discover agreement.
45	5	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.106517	4	Strong discover campaign rate spring production. Drive specific important wonder remain measure. Project arm always help.	5	Face movement make bad something with modern. Two citizen modern piece. Wish huge good magazine later assume carry worry.	4	Side hear identify school likely too.
46	5	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.108724	3	Manage bit research worry artist up. Small probably lay ability line growth decide include.	5	Style gas with wonder police woman. Service tough relate contain. Something often notice dark.	5	Real physical degree. Like partner arrive.
47	5	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.110616	2	Turn seek just enter its east. Cell policy camera owner beyond.	3	Debate heart race campaign play. Describe condition way success laugh indicate pick. Early speak standard poor child.	4	Style same own nor how at more need. Reveal employee new never event. Cut several stand full sit.
48	5	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.112575	4	Understand behind ever work somebody team simple. Decision nearly clear nearly whose TV quickly. Left subject police good common attack.	4	Right hear option although nation. Stock consumer some anyone. Task mouth recent.	1	Brother suddenly white political test future factor. Third interest create.
49	5	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.114433	4	Throw place fact admit third police agree. Suggest at marriage politics we. Operation safe ability edge individual drive history. Reality control follow ever foot.	2	Whole remember here fact cut join. Who eat case president PM.	5	First shoulder interesting page. Reflect minute of owner miss.
50	5	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.116054	2	Enjoy her Republican budget away real. Field agency term head explain. Focus especially near then home.	1	Within tell social call. Coach consider sometimes remember whom old finish. Director discover chance exist real box.	5	Impact try dog behind. Course move follow senior soldier across record.
51	6	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.117813	4	Product bank these support large player. Population guy yard hair. Deal also hope then guess claim.	5	Kind low always need ever close. Friend relationship eight involve realize parent blood. Traditional through different year fight herself arrive.	5	Sometimes but seven cost store. Option leader civil teacher.
52	6	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.119837	2	Way suffer set story. Suggest interest record across whole language fast. Card baby coach simply I meet.	4	Language source cup along force factor. Language whether friend couple my ask yeah. Option cultural friend city pass.	5	Figure finish successful shoulder. Increase society with include. Fight her southern tree these live.
53	6	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.121669	4	Television throw radio themselves could. Later adult interesting sister heart fund with. Challenge doctor dog increase account truth.	3	Leader official history professional use blood. Child hard style face about ok. Wind during commercial left study bit in. Decision other radio price through within me.	1	Event off prevent information save teacher. Hair vote light five back avoid. Sit action whole ball win certain.
54	6	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.123698	2	Including author impact voice however common mean. Person recent small feel painting party position.	4	Most phone despite half its actually sister. Appear during stay ok state involve. Population think price general treat.	5	Behind both others figure pass bit. Down movement now side say him produce.
55	6	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.125579	3	Piece run kid suggest for more board. Concern city final your. Role respond available difference we it.	3	Wonder later talk while bill western floor worry. Two member tend near miss artist plant. Second traditional visit respond soon company edge. Before pressure meeting firm whatever born manager.	3	Whom piece whom will response recent maintain. Study important business. Strategy movement edge enjoy.
56	6	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.127507	2	Lawyer trip happy movie. Board building statement whatever ago staff. Affect visit eight whole. Animal claim job too enough.	5	Step pressure character catch key control.	3	Worker month since political check food. Above could industry society.
57	6	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.129818	4	Sound nice garden. Traditional physical public sometimes.	2	Above plan true hand. Drug statement huge whom heart.	4	Deal city along compare. Rate sometimes without build mission partner compare certainly.
58	6	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.132006	2	Mrs only usually defense. Forward through name Mrs professor help. Southern card popular else with history common individual.	5	Health question full cup fight.	4	Center though religious garden training condition. Century air American media another however provide local.
59	6	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.133843	3	Value firm since Mr. Article city letter fire. Over office wall keep three site. Simple treatment trade floor song fall born heart.	4	Common during trouble maintain season anything. Bad bad see child dark reason. East player respond agency perform.	3	Thought radio general alone set politics hundred. Want each identify sell so. Red detail watch inside amount.
60	6	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.13568	5	Age again stop identify star lose war.	4	Until agreement area response system feel standard. Sure rise even five toward player. Nice man natural similar million rock range. Decision record trip conference attention morning.	1	Yes report center agency camera site arm. Describe investment exactly make force student exactly law. Raise task institution base he fire deal.
61	7	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.138641	1	Need call subject old billion politics. Star course short.	5	Meeting treat after. Personal news night return.	1	Others election movement listen if nothing crime.
62	7	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.140765	5	Indicate strong computer environment general. View trade mention future.	5	Suggest yeah information car try early. Improve Republican article all give within interview.	5	End myself article air. Worry hit read model PM experience their.
63	7	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.142591	2	Most move sign plan. Stop check with method raise.	5	Check car nor start. Ball weight position civil fine.	5	Challenge seven pay billion. Environmental table herself be fish.
64	7	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.144324	1	Office ability state west total government magazine. Our skill off thus the prevent. According far none.	1	Officer history significant lose evidence first. Sell few speak western especially wife able charge.	3	Once dark daughter door account. Case benefit reflect possible behind across successful. Concern happen teacher special high amount.
65	7	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.14621	4	Now decade kind bar grow feeling. Sing every entire forward soon even.	2	Grow wish matter black be. Contain this cultural bad fly. On control west director.	4	Something quite end available turn thus appear.
66	7	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.148024	2	Institution truth whole nice evidence. Occur catch clear involve air music.	3	Change one ability fact official one ten first. Government push quality exactly. Quite think lay pressure right do.	2	Remember claim idea agency trial conference stuff game. Staff party interview bank let cut production.
67	7	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.149741	1	Ahead class give. Understand focus exist set town send least year. Local property card early base. Report door stand spring group skill.	4	Yet appear cold option. Short network close ask while investment several. Field order team represent cultural. Game need north truth understand he condition seem.	5	Arm business knowledge community church you government. Together total upon citizen under then. Himself environment trouble money on. Candidate money heavy million a.
68	7	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.151474	4	Stand college open claim herself. Person son save cut magazine happy how.	2	Second later beautiful lay. Write mean can walk wind sing.	4	Response important half and line model laugh. Wish open whom TV thank identify face service. Outside special policy tax rate. Field government plan think.
69	7	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.154446	5	Fact politics analysis nation who reflect stay worker. Marriage be reality wife different. Significant author movement light involve sport.	5	Type may nature seat bank. Outside production everything meeting Republican you per.	1	Thing quickly where break again husband hand. Shake challenge eight like. Also board manager travel drug perhaps majority ever.
70	7	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.157346	5	Push war every. Red how represent reason as. Tax agree surface factor source grow individual.	2	Personal thing case can. Career guess several protect author.	1	Street event strong. Important cover young system available. Hope argue each the pattern research.
71	8	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.159129	3	Dinner necessary think personal blood common on any. Republican believe his site at simple.	3	Eight standard see sound no several miss. Physical deep ever candidate standard prove begin show. Trial down charge know still chair.	5	Force social remember money head interesting. Laugh gas teach future.
72	8	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.160905	2	Hear within staff receive somebody industry. Nothing mission ball. Agency green play side offer structure.	4	Party former special technology result design their decade. Most surface without describe. Sense right first.	5	Member across Mr whom miss sister.
73	8	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.162493	3	Data well structure section along go into. Answer hotel either tend table. Wish message blood despite truth.	3	Suffer mission health how. Role national return treatment. Understand analysis into move early operation law indeed. Defense even who view.	3	Clear middle happy during. Clear deep of wind avoid day American. Chair court vote let home doctor.
74	8	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.164219	4	Who treat listen full couple. Claim whom special daughter. Ability because take program.	2	Fund sit police race traditional listen our. Quickly natural add once. Line perform try need speech hope.	4	Still community government from opportunity while know.
75	8	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.166951	4	Set rule fast visit record after risk. Product local would laugh huge thousand you.	2	Building democratic relate speak economy ok.	2	Nature present support personal world behind. Pm key subject body address guess easy fish. Change operation shake education think.
76	8	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.169353	1	Production series program hit outside us allow. Cost eat their high carry.	4	Can note finally alone. Field sea executive rather. Space class cost lot soldier matter.	2	Institution area term large study able. Pressure before environmental will meet herself American one. Activity indeed likely assume exactly area two.
77	8	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.171882	2	Lead cell market cut write. Four trade like.	3	Against tough modern these. Situation fact tree.	4	Exist music learn material manager into nearly. Debate huge method others better career. Even person president what everyone.
78	8	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.174229	3	On sport policy create score population. Actually police apply military stop. Affect administration make answer.	2	Main operation performance fight rather view. Perhaps can form field old none approach. Wrong mother begin population.	5	Girl physical today head appear blood dog. Group rock win.
79	8	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.176238	5	Article financial better professor bill player budget. Baby thousand enter. All cold power per.	3	Single keep during house baby hour issue. Relate seat threat product recently. Present court car a.	3	Speech both another sign day hard. Time learn beat wall serve school lawyer ahead.
80	8	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.17784	3	Law around lot here culture opportunity. This case recognize sure first. Them medical show factor approach. Sing art public standard southern person research.	3	Read yourself beat tend ready material. Do yard style decide put tend.	5	Run resource huge summer. Factor relate try who final.
81	9	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.179386	1	Nor employee material reflect. Anyone east there leg traditional himself item. Have old call bed total everyone tough ask.	4	View appear them need. Commercial performance tough behind real concern. Window side home stuff.	2	Audience board affect every. Her fire rule night various however. Structure score real street moment.
82	9	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.182105	2	Crime west meet improve hot music bad. Example involve forget product.	2	Others authority reason score through give least. Tree identify scene degree. Ever through government us.	5	Charge close successful trial. Strong however material interview once senior. Challenge night need stock decision. Blue apply agent affect.
83	9	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.185041	3	Administration place bed toward discuss friend strong professional. See best world above seat. Treat turn true allow human north.	4	Two west all along. Recent baby Republican friend myself reduce wide. Decision box agree send allow want every.	3	Sound present future brother. Special economic theory next maybe.
84	9	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.188798	3	Hour theory cause light charge drug. Situation feel control these. Eye tend require impact popular me.	5	Responsibility well above within. Moment radio per on tree brother city.	4	Five number never present child. Myself war senior dream type. Member huge whom down they rich.
85	9	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.191492	1	Heart force assume manage.	5	Time management soon. Control need detail item middle. People tough sea many gas my carry.	3	Although whether young floor mouth art. Win politics tend suggest budget. Admit interest rest method beautiful peace southern.
86	9	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.193369	2	Apply help size red agree audience.	3	Become goal again century glass state. Raise PM per can by suddenly.	2	Difference surface then couple. Those inside beautiful forget despite. Between north manage operation might place hold watch.
87	9	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.19528	2	Skin enough prove necessary appear adult more trade.	3	Maintain nature find have task apply relationship fast. Resource claim figure maintain agency another. Across share month environmental bill.	3	Student more from business. Manage there fine manager fact conference pay.
88	9	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.197064	2	Best know tree call room upon former. Debate be loss school tend present forward. Stage condition black small act office.	4	Red town several rather book station represent. Father condition baby. Send along stop budget important long Congress. Nor right expect sing over either action.	5	List against own mean throw hospital day life. Serve girl left. Return rule eight decision the general.
89	9	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.198938	1	Industry write campaign kid. Catch kitchen along push green word line. Thus concern entire almost laugh involve.	2	Left vote today assume life finish. Assume if half discussion since understand.	3	Media risk woman century scientist bit. Black I and character explain increase language.
90	9	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.200641	2	Effect memory occur program total political seat finish.	1	Old box attack nothing the message fine career. Relate career TV test eight us.	4	Question occur most. Sister southern home character discuss may enough.
91	10	ChIJNZloNTd-j4ARxGMOXZp7KfI	2018-08-09 00:10:21.202299	5	Herself again world strategy represent. Friend everybody deal cell find resource poor.	2	Kitchen himself seek serve agree.	1	Character think clearly nearly nothing ask discuss. Instead myself she former off song.
92	10	ChIJfcaly4eAhYARSIvvfFpH64w	2018-08-09 00:10:21.203939	2	Friend war begin under he need. Join week use who.	3	Go break close mother. Middle first part skin sell.	2	Never race medical peace respond tree. How alone whatever himself property.
93	10	ChIJlfC_eYKAhYARhcWC559q0jc	2018-08-09 00:10:21.205645	1	Sport hospital case example everybody. Discover case item money there reason information. Most player discover peace.	1	But draw course impact before mission wonder. Month blue spring way.	1	Myself deep political. Political tough note. Participant tell specific run gas.
94	10	ChIJVRnYLHyAhYARhl2ZVJFi5iU	2018-08-09 00:10:21.207394	2	Deal big argue piece around apply. Decide million green record country mouth marriage. Produce force all by yourself.	3	Listen tonight nice new part culture likely today. Sign figure skill own. Series throw Democrat technology computer I. Beautiful since put hear.	4	Yet change Congress next house. Capital economic concern much.
95	10	ChIJ5UiqQJCAhYAR5L5rAgjuf_0	2018-08-09 00:10:21.20914	1	Successful large stop science second east. Continue wall share.	1	Song probably quality say enjoy money small. Just science charge none economy. Program generation mind rate wrong.	3	All leave man world. Know head can leave value.
96	10	ChIJKT_dq7GAhYARpHV3vs0HUWQ	2018-08-09 00:10:21.210792	3	Defense join protect short. College candidate design common month.	3	Amount few expert movie. Director though force any type while.	4	Process five feel last. Beyond go could return ago. Start goal since. Modern field sort site.
97	10	ChIJMygdeCZ-j4ARKDtpQiICwUo	2018-08-09 00:10:21.212514	5	Assume respond put. Top successful paper can manage perform necessary scene.	4	Professor thus of expect change. Most fight among big hundred reality pretty. Various receive operation notice.	1	Test visit establish popular. Bill three century much lead.
98	10	ChIJzf0lTbCAhYARqz-tqaIyJaY	2018-08-09 00:10:21.214098	5	Agreement admit if defense process for friend shoulder. Great prove few movie technology prevent kind.	4	Hundred so good book structure. Cut break own much stop.	5	Plant work camera site play language. On blood return remember. Long every bring pattern very. However hope country deep career.
99	10	ChIJh_24QJ-AhYAR_xbUNVN2Xns	2018-08-09 00:10:21.21568	2	Imagine brother send. Kitchen seven course upon.	5	Understand owner spend somebody. Look commercial base quality.	2	Go myself doctor. And former best on security actually worry.
100	10	ChIJk8dm4J6AhYAR8MCM6inxTgE	2018-08-09 00:10:21.21744	5	Actually community matter. Find actually before share program though.	1	Key station increase first. Affect it until type difficult building cause.	4	End fast piece financial follow tonight. Short husband door manager program size.
\.


--
-- Name: reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.reviews_review_id_seq', 100, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY public.users (user_id, email, fname, lname, password, zipcode, icon) FROM stdin;
1	ericagarrett@hotmail.com	Joshua	Salazar	)5BxOzv1%j	67112	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
2	raymond95@ray.com	Kelly	Tanner	GlbgHoq)!3	83239	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
3	michaelmiddleton@smith.com	Brett	Walsh	%+X7xEqj5W	14732	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
4	kellyschmitt@brown.com	Daniel	Jimenez	%2fUvJfOL9	55251	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
5	matthew08@yahoo.com	Wendy	Edwards	3liYh8jD!1	62416	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
6	natalie31@yahoo.com	Audrey	Johnson	5^jO2^Fs7i	20665	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
7	moraleslauren@crane.org	Adam	Allen	@3DcHaT047	32336	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
8	garciaelizabeth@hotmail.com	Theresa	Price	5SSxstgZ(K	90767	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
9	aschwartz@wood-mckinney.com	Tiffany	Blackburn	Yk_MJ3DqA!	51332	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
10	adam91@hotmail.com	Megan	Ellis	%+6ItM3vcY	67732	https://images.unsplash.com/photo-1491273289208-\n                      9340cb42e5d9?crop=entropy&fm=jpg&w=150&h=150&fit=crop
\.


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('public.users_user_id_seq', 10, true);


--
-- Name: dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.dishes
    ADD CONSTRAINT dishes_pkey PRIMARY KEY (dish_id);


--
-- Name: favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (favorite_id);


--
-- Name: restaurant_dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.restaurant_dishes
    ADD CONSTRAINT restaurant_dishes_pkey PRIMARY KEY (restaurant_dish_id);


--
-- Name: restaurants_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (restaurant_id);


--
-- Name: review_dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.review_dishes
    ADD CONSTRAINT review_dishes_pkey PRIMARY KEY (review_dish_id);


--
-- Name: reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: favorites_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(restaurant_id);


--
-- Name: favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: restaurant_dishes_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.restaurant_dishes
    ADD CONSTRAINT restaurant_dishes_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(dish_id);


--
-- Name: restaurant_dishes_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.restaurant_dishes
    ADD CONSTRAINT restaurant_dishes_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(restaurant_id);


--
-- Name: review_dishes_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.review_dishes
    ADD CONSTRAINT review_dishes_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(dish_id);


--
-- Name: review_dishes_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.review_dishes
    ADD CONSTRAINT review_dishes_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.reviews(review_id);


--
-- Name: reviews_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(restaurant_id);


--
-- Name: reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

