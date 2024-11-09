NAME = inception

SRCS_DIR = ./srcs

.PHONY: $(NAME) all run clean fclean re

$(NAME):
	cd $(SRCS_DIR) && docker compose build

all: $(NAME)

run: $(NAME)
	cd $(SRCS_DIR) && docker compose up

clean:
	docker builder prune -af

fclean: clean

re: fclean all

debug:
	cd $(SRCS_DIR) && docker compose --progress=plain build --no-cache
