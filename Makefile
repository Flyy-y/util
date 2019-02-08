# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cbreisch <cbreisch@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/02/27 14:18:33 by cbreisch          #+#    #+#              #
#    Updated: 2019/02/08 14:18:46 by cbreisch         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME		:= {name}
TARGET		:= {target}
LIBRARY		:= {library}

SRCDIR		:= {srcdir}
INCDIR		:= {incdir}
BUILDDIR	:= {builddir}
TARGETDIR	:= {tardir}
SRCEXT		:= {srcext}
OBJEXT		:= {objext}

CC			:= {cc}
CFLAGS		:= {cflags}
MAKEDEP		:= {makedep}
LIB			:= {lib}
INC			:= -I$(INCDIR) {inc}
LINKER		:= {linker}
RM			:= {rm}
MKDIR		:= {mkdir}

SOURCES     := {sources}

OBJECTS     := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))

CUR_COLOR	:= \033[0;93m
COM_COLOR	:= \033[0;94m
OBJ_COLOR	:= \033[0;90m
TAR_COLOR	:= \033[0;92m
OK_COLOR	:= \033[0;32m
ERROR_COLOR	:= \033[0;31m
WARN_COLOR	:= \033[0;33m
NO_COLOR	:= \033[m

PRINTF 		:= printf "%-20b%-55b%b"
OK_STRING	:= "[OK]"
ERROR_STRING:= "[ERROR]"
WARN_STRING	:= "[WARNING]"
COM_STRING	:= "Compiling"
LIN_STRING	:= "Linking"
IND_STRING	:= "Indexing"
DEL_STRING	:= "Deleted"





#
#	RULES
#
$(NAME): all

all: makedep $(TARGETDIR)/$(TARGET)

re: fclean all

fre: depclean fclean all

clean: #Delete build directory
	@$(RM) $(OBJECTS) $(BUILDDIR) 2> /dev/null | true
	@$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(DEL_STRING)$(TAR_COLOR) build files" "$(OK_COLOR)$(OK_STRING)$(NO_COLOR)\n";

fclean: clean #Delete build and target directories
	@$(RM) $(TARGETDIR)/$(TARGET) $(TARGETDIR)/$(TARGET).dSYM $(TARGETDIR) 2> /dev/null | true
	@$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(DEL_STRING)$(TAR_COLOR) binary files" "$(OK_COLOR)$(OK_STRING)$(NO_COLOR)\n";

depclean:
	@$(foreach dep,$(MAKEDEP),make -C $(dep) clean;)

depfclean:
	@$(foreach dep,$(MAKEDEP),make -C $(dep) clean;)

norm:
	@norminette $(SOURCES)

normcheck:
	@echo "$(shell norminette $(SOURCES) | grep -E '^(Error|Warning)')" Norme check OK

makedep:
	@$(foreach dep,$(MAKEDEP),make -C $(dep);)





#
#	LINKING
#
ifeq ($(LIBRARY), FALSE)
$(TARGETDIR)/$(TARGET): $(OBJECTS)
	@$(MKDIR) $(dir $@)
	@$(CC) $(CFLAGS) $(INC) -o $(TARGETDIR)/$(TARGET) $^ $(LIB) 2> $@.log; \
		RESULT=$$?; \
		if [ $$RESULT -ne 0 ]; then \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(LIN_STRING)$(TAR_COLOR) $@" "$(ERROR_COLOR)$(ERROR_STRING)$(NO_COLOR)\n"; \
		elif [ -s $@.log ]; then \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(LIN_STRING)$(TAR_COLOR) $@" "$(WARN_COLOR)$(WARN_STRING)$(NO_COLOR)\n"; \
		else  \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(LIN_STRING)$(TAR_COLOR) $@" "$(OK_COLOR)$(OK_STRING)$(NO_COLOR)\n"; \
		fi; \
		cat $@.log; \
		rm -f $@.log; \
		exit $$RESULT
else
$(TARGETDIR)/$(TARGET): $(OBJECTS)
	@$(MKDIR) $(dir $@)
	@$(LINKER) $(TARGETDIR)/$(TARGET) $^ 2> $@.log; \
		RESULT=$$?; \
		if [ $$RESULT -ne 0 ]; then \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(LIN_STRING)$(TAR_COLOR) $@" "$(ERROR_COLOR)$(ERROR_STRING)$(NO_COLOR)\n"; \
		elif [ -s $@.log ]; then \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(LIN_STRING)$(TAR_COLOR) $@" "$(WARN_COLOR)$(WARN_STRING)$(NO_COLOR)\n"; \
		else  \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(LIN_STRING)$(TAR_COLOR) $@" "$(OK_COLOR)$(OK_STRING)$(NO_COLOR)\n"; \
		fi; \
		cat $@.log; \
		rm -f $@.log; \
		exit $$RESULT
endif





#
#	OBJECTS BUILDING
#
$(BUILDDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	@$(MKDIR) $(dir $@)
	@$(CC) $(CFLAGS) $(INC) -c -o $@ $< 2> $@.log; \
		RESULT=$$?; \
		if [ $$RESULT -ne 0 ]; then \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(COM_STRING)$(OBJ_COLOR) $@" "$(ERROR_COLOR)$(ERROR_STRING)$(NO_COLOR)\n"; \
		elif [ -s $@.log ]; then \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(COM_STRING)$(OBJ_COLOR) $@" "$(WARN_COLOR)$(WARN_STRING)$(NO_COLOR)\n"; \
		else  \
			$(PRINTF) "$(CUR_COLOR)$(NAME) > " "$(COM_COLOR)$(COM_STRING)$(OBJ_COLOR) $(@F)" "$(OK_COLOR)$(OK_STRING)$(NO_COLOR)\n"; \
		fi; \
		cat $@.log; \
		rm -f $@.log; \
		exit $$RESULT
	




nicemoulinette:
	@(read -p "Are you sure ? [y/N]: " sure && case "$$sure" in [yY]) true;; *) false;; esac)
	@mv $(SOURCES) .
	@mv $(shell du -a $(INCDIR) | awk '{print $$2}' | grep '\.h') .
	@$(RM) $(SRCDIR) | true
	@$(RM) $(INCDIR) | true

#Non-File Targets
.PHONY: all re fre directories clean fclean depclean depfclean norm normcheck makedep nicemoulinette

