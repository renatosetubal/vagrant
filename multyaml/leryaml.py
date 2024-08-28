import yaml

# Carrega o arquivo YAML
with open('machines.yml', 'r') as arquivo:
    dados = yaml.safe_load(arquivo)

# Acessa os dados
nome = dados[0]['disk']['size']
# ['nome']
# idade = dados['pessoa']['idade']
# habilidades = dados['pessoa']['habilidades']
nome = dados[0]['enableport']['enable']
print(f"Nome: {nome}")

# print(f"Idade: {idade}")
# print(f"Habilidades: {', '.join(habilidades)}")
