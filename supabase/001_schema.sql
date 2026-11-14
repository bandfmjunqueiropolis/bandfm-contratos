-- Execute no SQL Editor de um projeto Supabase NOVO.
create extension if not exists pgcrypto;
create table public.clientes (
 id uuid primary key default gen_random_uuid(), razao_social text not null, nome_fantasia text default '', cnpj text default '', endereco text default '', numero text default '', bairro text default '', cidade text default '', cep text default '', telefone text default '', inscricao_estadual text default '', email text default '', responsavel text default '', aniversario date, criado_em timestamptz not null default now(), atualizado_em timestamptz not null default now()
);
create unique index clientes_cnpj_unique on public.clientes (regexp_replace(cnpj,'[^0-9]','','g')) where length(regexp_replace(cnpj,'[^0-9]','','g'))=14;
create sequence public.contrato_numero_seq start 1;
create table public.contratos (
 id uuid primary key default gen_random_uuid(), numero bigint not null unique default nextval('public.contrato_numero_seq'), cliente_id uuid not null references public.clientes(id) on delete restrict, cliente_snapshot jsonb not null, status text not null default 'rascunho' check(status in ('rascunho','emitido','cancelado')), inicio date, termino date, insercoes_diarias integer not null default 0 check(insercoes_diarias>=0), insercoes_mensais integer not null default 0 check(insercoes_mensais>=0), observacoes text not null default '', valor_mensal numeric(12,2) not null default 0 check(valor_mensal>=0), valor_total numeric(12,2) not null default 0 check(valor_total>=0), forma_pagamento text not null default 'pix' check(forma_pagamento in ('vista','banco','carteira','pix')), dia_pagamento integer not null default 10 check(dia_pagamento in (5,10,15,20,25)), local_assinatura text not null default 'Junqueirópolis', data_assinatura date, criado_por uuid not null default auth.uid() references auth.users(id), criado_em timestamptz not null default now(), atualizado_em timestamptz not null default now()
);
create table public.programacoes (
 id uuid primary key default gen_random_uuid(), contrato_id uuid not null references public.contratos(id) on delete cascade, produto text not null check(produto in ('TESTEMUNHAL','ROTATIVO','FLASH','PEDÁGIO','PROJETO','CHEGA JUNTO')), horario_inicio text not null default '', horario_fim text not null default '', duracao_segundos integer check(duracao_segundos is null or duracao_segundos>0), observacao text not null default '', unique(contrato_id,produto)
);
create table public.parcelas (
 id uuid primary key default gen_random_uuid(), contrato_id uuid not null references public.contratos(id) on delete cascade, competencia date not null, vencimento date, valor numeric(12,2) not null default 0 check(valor>=0), boleto text not null default '', unique(contrato_id,competencia)
);
create index contratos_cliente_idx on public.contratos(cliente_id);
create index contratos_criado_em_idx on public.contratos(criado_em desc);
create index parcelas_contrato_idx on public.parcelas(contrato_id);
create or replace function public.atualizar_timestamp() returns trigger language plpgsql set search_path = '' as $$begin new.atualizado_em=now();return new;end;$$;
create trigger clientes_atualizado before update on public.clientes for each row execute function public.atualizar_timestamp();
create trigger contratos_atualizado before update on public.contratos for each row execute function public.atualizar_timestamp();
-- Somente usuários autenticados podem acessar dados; habilite usuários apenas da equipe autorizada.
alter table public.clientes enable row level security;
alter table public.contratos enable row level security;
alter table public.programacoes enable row level security;
alter table public.parcelas enable row level security;
create policy clientes_equipe on public.clientes for all to authenticated using (true) with check(true);
create policy contratos_equipe on public.contratos for all to authenticated using (true) with check(true);
create policy programacoes_equipe on public.programacoes for all to authenticated using (true) with check(true);
create policy parcelas_equipe on public.parcelas for all to authenticated using (true) with check(true);
revoke all on sequence public.contrato_numero_seq from public, anon;
grant usage on sequence public.contrato_numero_seq to authenticated;
-- Segurança adicional: nunca expor service_role no navegador.
