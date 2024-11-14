NAME = inception

SRCS_DIR = ./srcs

.PHONY: $(NAME) all run clean fclean re

$(NAME):
	cd $(SRCS_DIR) && docker compose build

all: $(NAME)

run:
	cd $(SRCS_DIR) && docker compose up

clean:
	docker builder prune -af

fclean: clean
	cd $(SRCS_DIR) && docker compose down -t 0
	docker image rm -f inception-mariadb inception-wordpress inception-nginx
	docker volume rm -f mariadb_data wordpress_data
	docker network rm -f backend

re: fclean all

debug:
	cd $(SRCS_DIR) && docker compose --progress=plain build --no-cache
