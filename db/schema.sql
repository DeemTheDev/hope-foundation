--
-- PostgreSQL database dump
--

\restrict dOg4ogXP8O1eU5VAo8ywVVLWDnisLs8lqLHEaVcM9nE8VIBo1NABnjg1fXqcZVx

-- Dumped from database version 16.15 (9355089)
-- Dumped by pg_dump version 16.15

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: authorised_organisations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authorised_organisations (
    id integer NOT NULL,
    organisation_id integer NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL
);


--
-- Name: authorised_organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authorised_organisations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authorised_organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authorised_organisations_id_seq OWNED BY public.authorised_organisations.id;


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id integer NOT NULL,
    content text NOT NULL,
    type character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: donations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.donations (
    id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    donation_date date NOT NULL,
    organisation_id integer NOT NULL,
    donor_id character varying(100) NOT NULL
);


--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.donations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.donations_id_seq OWNED BY public.donations.id;


--
-- Name: organisation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organisation (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    description character varying(100) NOT NULL,
    address character varying(100) NOT NULL,
    website character varying(100),
    profile_image_url character varying(100),
    image_url character varying(100)
);


--
-- Name: organisation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organisation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organisation_id_seq OWNED BY public.organisation.id;


--
-- Name: organisation_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organisation_images (
    id integer NOT NULL,
    organisation_id integer NOT NULL,
    image_url character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: organisation_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organisation_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisation_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organisation_images_id_seq OWNED BY public.organisation_images.id;


--
-- Name: organisation_social; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organisation_social (
    id integer NOT NULL,
    organisation_id integer NOT NULL,
    facebook_url character varying(255),
    twitter_url character varying(255),
    instagram_url character varying(255)
);


--
-- Name: organisation_social_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organisation_social_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisation_social_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organisation_social_id_seq OWNED BY public.organisation_social.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    clerk_id character varying(50) NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: authorised_organisations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorised_organisations ALTER COLUMN id SET DEFAULT nextval('public.authorised_organisations_id_seq'::regclass);


--
-- Name: donations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donations ALTER COLUMN id SET DEFAULT nextval('public.donations_id_seq'::regclass);


--
-- Name: organisation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation ALTER COLUMN id SET DEFAULT nextval('public.organisation_id_seq'::regclass);


--
-- Name: organisation_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation_images ALTER COLUMN id SET DEFAULT nextval('public.organisation_images_id_seq'::regclass);


--
-- Name: organisation_social id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation_social ALTER COLUMN id SET DEFAULT nextval('public.organisation_social_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: authorised_organisations authorised_organisations_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorised_organisations
    ADD CONSTRAINT authorised_organisations_email_key UNIQUE (email);


--
-- Name: authorised_organisations authorised_organisations_organisation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorised_organisations
    ADD CONSTRAINT authorised_organisations_organisation_id_key UNIQUE (organisation_id);


--
-- Name: authorised_organisations authorised_organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorised_organisations
    ADD CONSTRAINT authorised_organisations_pkey PRIMARY KEY (id);


--
-- Name: blog_posts blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: donations donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: organisation organisation_address_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_address_key UNIQUE (address);


--
-- Name: organisation organisation_description_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_description_key UNIQUE (description);


--
-- Name: organisation organisation_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_email_key UNIQUE (email);


--
-- Name: organisation_images organisation_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation_images
    ADD CONSTRAINT organisation_images_pkey PRIMARY KEY (id);


--
-- Name: organisation organisation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (id);


--
-- Name: organisation_social organisation_social_organisation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation_social
    ADD CONSTRAINT organisation_social_organisation_id_key UNIQUE (organisation_id);


--
-- Name: organisation_social organisation_social_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation_social
    ADD CONSTRAINT organisation_social_pkey PRIMARY KEY (id);


--
-- Name: organisation organisation_website_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_website_key UNIQUE (website);


--
-- Name: users users_clerk_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_clerk_id_key UNIQUE (clerk_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: authorised_organisations authorised_organisations_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorised_organisations
    ADD CONSTRAINT authorised_organisations_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: blog_posts blog_posts_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organisation(id) ON DELETE CASCADE;


--
-- Name: organisation_images organisation_images_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation_images
    ADD CONSTRAINT organisation_images_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: organisation_social organisation_social_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisation_social
    ADD CONSTRAINT organisation_social_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- PostgreSQL database dump complete
--

\unrestrict dOg4ogXP8O1eU5VAo8ywVVLWDnisLs8lqLHEaVcM9nE8VIBo1NABnjg1fXqcZVx

