import streamlit as st


st.set_page_config(layout="wide", 
                   page_icon=":abacus:", 
                   page_title="Calculadora do MEI")

st.title("Calculadora do MEI")

tab1, tab2, tab3 = st.tabs(["💰 Caixa", "💲 Rentabilidade", "🏷️ Precificação"])

def formatar_moeda(valor):
    return f"R$ {valor:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

with tab1:

    st.header("Como está o seu caixa?")
    st.write("Aqui você pode calcular apenas inserindo os dados.")
    st.info("A liquidez é um indicador financeiro que mede a capacidade de uma empresa em honrar suas dívidas de curto prazo. Quanto maior a liquidez, melhor é a saúde financeira da empresa.")

    st.info("Liquidez seca considera o caixa, aplicações financeiras e estoque(depende do giro de estoque). Já a liquidez imediata considera apenas o caixa e aplicações financeiras.")
    with st.form("Entradas", clear_on_submit=True):

        caixa = st.number_input("Digite o valor médio do caixa:", min_value=0.0)
        aplicacao_financeiras = st.number_input("Digite o valor médio das aplicações financeiras:", min_value=0.0)
        estoque = st.number_input("Digite o valor médio do estoque:", min_value=0.0)
        dividas = st.number_input("Digite o valor médio das dívidas:", min_value=0.0)

        submitted = st.form_submit_button("Calcular")

        if submitted:
            if caixa == 0 or aplicacao_financeiras == 0 or estoque == 0 or dividas == 0:
                st.warning("Nenhum dos valores pode ser zero para o cálculo da liquidez.")
            elif dividas == 0:
                st.warning("O valor das dívidas não pode ser zero para o cálculo da liquidez.")
            elif caixa < 0 or aplicacao_financeiras < 0 or estoque < 0 or dividas < 0:
                st.warning("Nenhum dos valores pode ser negativo para o cálculo da liquidez.")
            else:

                liquidez_seca = (caixa + aplicacao_financeiras) / dividas if dividas != 0 else float('inf')
                liquidez_imediata = (caixa + aplicacao_financeiras + estoque) / dividas if dividas != 0 else float('inf')

                col1, col2 = st.columns(2)
                with col1:
                    st.metric("Liquidez Seca", f"{liquidez_seca:.2f}")
                    if liquidez_seca < 1:
                        st.warning("A liquidez seca está abaixo de 1, o que indica que a empresa pode ter dificuldades em honrar suas dívidas de curto prazo.")
                    else:
                        st.success("A liquidez seca está acima de 1, o que indica que a empresa tem capacidade de honrar suas dívidas de curto prazo.")
                with col2:
                    st.metric("Liquidez Imediata", f"{liquidez_imediata:.2f}")
                    if liquidez_imediata < 1:
                        st.warning("A liquidez imediata está abaixo de 1, o que indica que a empresa pode ter dificuldades em honrar suas dívidas de curto prazo.")
                    else:
                        st.success("A liquidez imediata está acima de 1, o que indica que a empresa tem capacidade de honrar suas dívidas de curto prazo.")

                st.subheader("Quanto você pode retirar de dinheiro do Caixa?")

                if liquidez_imediata > 1.5:
                    st.success("A empresa está em uma boa situação financeira e pode retirar dinheiro do caixa com segurança.")
                elif liquidez_seca > 1:
                    st.info("A empresa está em uma situação financeira razoável, mas deve ter cautela ao retirar dinheiro do caixa.")
                else:
                    st.warning("A empresa está em uma situação financeira delicada e deve evitar retirar dinheiro do caixa.")

        
with tab2:
    st.subheader("Rentabilidade do seu negócio")
    st.info("Agora vamos calcular a capacidade de gerar valor.")

    with st.form("Rentabilidade", clear_on_submit=True):

        faturamento = st.number_input("Digite o valor médio do faturamento:", min_value=0.1)
        custos = st.number_input("Digite o valor médio de todos os custos:", min_value=0.0)

        lucro_operacional = faturamento - custos
        margem_lucro =(lucro_operacional / faturamento)

        submitted = st.form_submit_button("Calcular")

        if submitted:
            if faturamento == 0 or custos == 0:
                st.warning("Nenhum dos valores pode ser zero para o cálculo da rentabilidade.")
            elif faturamento < 0 or custos < 0:
                st.warning("Nenhum dos valores pode ser negativo para o cálculo da rentabilidade.")
            else:
                col1, col2 = st.columns(2)
                with col1:
                    st.metric("Lucro Operacional", formatar_moeda(lucro_operacional))
                    if lucro_operacional < 0:
                        st.warning("O lucro operacional está negativo, o que indica que a empresa está operando com prejuízo.")
                    else:
                        st.success("O lucro operacional está positivo, o que indica que a empresa está operando com lucro.")
                with col2:
                    st.metric("Margem de Lucro", f"{margem_lucro:.2f}%")
                    if margem_lucro < 10:
                        st.warning("A margem de lucro está abaixo de 10%, o que indica que a empresa tem uma baixa rentabilidade.")
                    else:
                        st.success("A margem de lucro está acima de 10%, o que indica que a empresa tem uma boa rentabilidade.")

    with st.form("Retabilidade em Marketing", clear_on_submit=True):

        st.info("O ROAS é um indicador que mede a eficácia de uma campanha de marketing.")
        investimento = st.number_input("Digite o valor médio do investimento em marketing:", min_value=0.0)
        vendas = st.number_input("Digite o valor médio das vendas geradas pelo marketing:", min_value=0.0)

        roas = (vendas / investimento) * 100 if investimento != 0 else float('inf')

        submitted = st.form_submit_button("Calcular ROAS")

        if submitted:
            if investimento == 0 or vendas == 0:
                st.warning("Nenhum dos valores pode ser zero para o cálculo do ROAS.")
            elif investimento < 0 or vendas < 0:
                st.warning("Nenhum dos valores pode ser negativo para o cálculo do ROAS.")
            else:
                st.metric("ROAS", f"{roas:.2f}%")
                if roas < 100:
                    st.warning("O ROAS está abaixo de 100%, o que indica que a campanha de marketing não está sendo eficaz.")
                else:
                    st.success("O ROAS está acima de 100%, o que indica que a campanha de marketing está sendo eficaz.")

with tab3:
    st.subheader("Precificação do seu produto ou serviço")
    st.info("Agora vamos calcular o preço de venda do seu produto ou serviço.")

    with st.form("Precificação", clear_on_submit=True):

        custo_produto = st.number_input("Digite o valor médio do custo do produto ou serviço:", min_value=0.0)
        margem_lucro_desejada = st.number_input("Digite a margem de lucro desejada (%):", min_value=0.0)

        preco_venda = custo_produto * (1 + (margem_lucro_desejada / 100))

        submitted = st.form_submit_button("Calcular Preço de Venda")

        if submitted:
            if custo_produto == 0 or margem_lucro_desejada == 0:
                st.warning("Nenhum dos valores pode ser zero para o cálculo do preço de venda.")
            elif custo_produto < 0 or margem_lucro_desejada < 0:
                st.warning("Nenhum dos valores pode ser negativo para o cálculo do preço de venda.")
            else:
                st.metric("Preço de Venda Sugerido", formatar_moeda(preco_venda))
                st.success(f"O preço de venda sugerido para atingir a margem de lucro desejada é {formatar_moeda(preco_venda)}.")