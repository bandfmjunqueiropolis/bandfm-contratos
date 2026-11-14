# BAND FM 88,7 — Contratos v1.0

Aplicação React/Vite/TypeScript com Supabase e impressão A4.

## Instalação
1. Crie um projeto Supabase **dedicado**.
2. Execute `supabase/001_schema.sql` no SQL Editor (uma vez).
3. Em Authentication, desabilite cadastro público (Signups) e crie manualmente os usuários autorizados.
4. Copie `.env.example` para `.env.local` e configure URL e chave publicável (anon/publishable).
5. Execute `npm install` e `npm run dev`.
6. Entre com email/senha. Cadastre o cliente, crie o contrato e use **Imprimir / Salvar PDF**.
7. Para publicar: `npm run build` e sirva `dist/` em HTTPS com fallback SPA para `index.html`.

## Importante
- O contrato é renderizado em HTML/CSS e convertido em PDF pela opção **Salvar como PDF** do navegador (Chrome/Edge). Não há geração de PDF no servidor nesta versão.
- A referência da logomarca foi recortada da foto enviada e pode ter baixa resolução. Substitua `public/logo-referencia.png` pela arte oficial de alta qualidade mantendo o nome.
- O layout é uma **reconstrução aproximada**, fiel aos campos e estrutura, mas requer homologação visual/jurídica contra o formulário físico.
- O formulário original contém informações históricas; valide razão social, CNPJ, endereço e dados fiscais da emissora antes de emitir documentos reais.
- A primeira versão não registra baixa de pagamento, não emite nota fiscal e não contém assinatura eletrônica.
- RLS desta versão concede acesso a **todos os usuários autenticados**. Convide apenas usuários internos autorizados. Para equipes com papéis distintos, implemente RBAC antes da produção.
- Numeração usa sequência PostgreSQL e pode apresentar lacunas após transações canceladas; números não são reutilizados.
- O documento impresso é gerado a partir dos dados salvos e de seu snapshot de cliente.
