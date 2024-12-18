NAME = inception

SRCS_DIR = ./srcs
SECRETS_DIR = ./secrets
SSL_CERT = $(SECRETS_DIR)/amoutill.42.fr.crt
SSL_KEY = $(SECRETS_DIR)/amoutill.42.fr.key

.PHONY: $(NAME) all run cert clean fclean re

$(NAME): cert
	cd $(SRCS_DIR) && docker compose build

all: $(NAME)

stupid_vols:
	mkdir -p ~/data/mariadb
	mkdir -p ~/data/wordpress

up: cert stupid_vols
	cd $(SRCS_DIR) && docker compose up

upd: cert stupid_vols
	cd $(SRCS_DIR) && docker compose up -d

down:
	cd $(SRCS_DIR) && docker compose down

downv:
	cd $(SRCS_DIR) && docker compose down --volumes

clean:
	docker builder prune -af

fclean: clean
	cd $(SRCS_DIR) && docker compose down --volumes -t 0
	docker image rm -f inception-mariadb inception-wordpress inception-nginx
	docker volume rm -f mariadb_data wordpress_data
	docker network rm -f backend
	rm -f $(SSL_CERT) $(SSL_KEY)
	sudo rm -rf ~/data/mariadb ~/data/wordpress

$(SSL_KEY) $(SSL_CERT):
	openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
	-keyout $(SSL_KEY) -out $(SSL_CERT) \
	-subj \
	"/C=FR/ST=Normandy/L=Le Havre/O=42/OU=Students/CN=amoutill.42.fr/emailAddress=amoutill@student.42lehavre.fr"

cert: $(SSL_KEY) $(SSL_CERT)

re: fclean all

debug:
	cd $(SRCS_DIR) && docker compose --progress=plain build --no-cache
