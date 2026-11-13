-- Rode no Supabase: SQL Editor > New query > Run

create table if not exists public.contratos (
  id               uuid primary key default gen_random_uuid(),
  numero           bigint generated always as identity,   -- Nº do contrato (automático)
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  razao_social     text,
  nome_fantasia    text,
  endereco         text,
  numero_end       text,
  bairro           text,
  cidade           text,
  cep              text,
  fone             text,
  cnpj             text,
  inscr            text,
  email            text,
  responsavel      text,
  aniversario      date,

  roteiro          jsonb not null default '{}'::jsonb,    -- produtos, horários e tempos
  obs              text,
  insercoes_diarias  text,
  insercoes_mensais  text,
  inicio           date,
  termino          date,

  valor_mensal     text,
  valor_total      text,
  formas_pagamento text[] not null default '{}',
  dia_pagamento    text,
  parcelas         jsonb not null default '[]'::jsonb,    -- 12 meses: ano, dia, valor, boleto

  data_assinatura  date,
  atendente        text
);

create unique index if not exists contratos_numero_idx on public.contratos (numero);

-- Segurança: só usuários logados acessam os dados
alter table public.contratos enable row level security;

drop policy if exists "equipe acessa contratos" on public.contratos;
create policy "equipe acessa contratos"
  on public.contratos
  for all
  to authenticated
  using (true)
  with check (true);
