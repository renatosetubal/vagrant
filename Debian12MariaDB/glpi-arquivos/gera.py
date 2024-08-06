import bcrypt

# Gerar um hash
senha = b"renato"
hash = bcrypt.hashpw(senha, bcrypt.gensalt())
print(hash.decode())
