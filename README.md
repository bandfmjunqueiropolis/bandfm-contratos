# Contratos Band FM 88,7

Sistema simples para preencher, salvar (Supabase) e imprimir o contrato de publicidade.

## Instalação

1. **Banco de dados:** no Supabase, abra *SQL Editor*, cole o conteúdo de `schema.sql` e clique em *Run*.
2. **Usuários:** em *Authentication > Users > Add user*, crie o e-mail e a senha de cada pessoa da equipe.
   Em *Authentication > Sign In / Providers*, desative "Allow new users to sign up" para que ninguém de fora crie conta.
3. **Código:** envie `index.html` para o repositório `bandfm-contratos` (branch `main`).
4. **Publicar (opcional):** no GitHub, *Settings > Pages > Deploy from a branch > main / root*.
   O sistema abre em `https://bandfmjunqueiropolis.github.io/bandfm-contratos/`.

## Segurança

- A chave `sb_publishable_...` pode ficar no código do navegador. Quem protege os dados é o login + RLS (feito no `schema.sql`).
- **Nunca** coloque a chave `secret` (ou `service_role`) no código nem no GitHub.
- O contrato contém dados de clientes (CNPJ, e-mail, telefone): por isso o acesso exige login.

## Uso

- **Novo contrato** → preencha → **Salvar** (o número do contrato é gerado automaticamente).
- **Preencher parcelas pelo período** monta os meses a partir de início, término, valor mensal e dia de pagamento.
- **Imprimir** salva e abre a impressão em A4. Na janela de impressão, desative "Cabeçalhos e rodapés".
- Pode também escolher "Salvar como PDF" no lugar da impressora.
