"""Ponto de entrada do aplicativo Calculadora MEI no Streamlit."""

from pathlib import Path
from runpy import run_path


if __name__ == "__main__":
    app = Path(__file__).resolve().parent / "financas" / "calculadora-mei" / "calculadora.py"
    run_path(str(app), run_name="__main__")