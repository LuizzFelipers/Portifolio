from agno.agent import Agent
from agno.tools.tavily import TavilyTools
from agno.models.groq import Groq
from dotenv import load_dotenv
import streamlit as st

load_dotenv()

st.set_page_config(page_title="Pesquisa de Produtos", page_icon=":bar_chart:", layout="wide")

agente = Agent(
    model=Groq(id="llama-3.3-70b-versatile", api_key=""),
    tools=[TavilyTools()],
    markdown=True,
    instructions="""Atue como um especialista em pesquisa de produtos para uma cantina escolar procure os produtos do cadápio e encontre as 5 melhores opções.
    Preciso que os fornecedores sejam o Costa atacadão, Super adega, assaí, dia a dia, americanas, atacadão. 
    TODOS ESSES FORNECEDORES DEVEM SER DE LUZIÂNIA-GO E VALPARAÍSO-GO.
    Preciso que você me retorne uma tabela com as seguintes colunas:
    - Nome do Produto
    - Preço
    - Fornecedor
    - Link do Produto
    """
)

input = st.text_input("Digite os produtos que deseja pesquisar (separados por vírgula):", "Coca-cola 200ml, Guaraná 200ml, Doritos de até 70g")
button = st.button("Pesquisar")

if button:

    
    agente.print_response(f"Pesquise os melhores preços desses produtos: {input}",stream=True)

