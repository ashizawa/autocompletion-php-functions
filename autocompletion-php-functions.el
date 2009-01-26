;;; autocomplete-php-function.el --- auto complete php functions.

;; Copyright (C) 2009  Kazutaka Ashizawa

;; Author: Kazutaka Ashizawa <k.ashizawa@gmail.com>
;; Keywords:

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;

;;; Code:

(require 'auto-complete)

(defcustom complete-functions-file "~/.emacs.d/php-functions"
  "completion file.")

(if (file-readable-p complete-functions-file)
    (with-temp-buffer
      (insert-file-contents complete-functions-file)
      (setq php-my-functions (split-string (buffer-string) "\n")))
  (if (file-writable-p complete-functions-file)
      (with-temp-buffer
        (setq php-my-functions (split-string (shell-command-to-string
                                              (concat "php -r 'foreach (get_defined_functions() as $vars) { foreach ($vars as $var) {echo \"$var\n\";}}'")) "\n"))
        (mapcar (lambda (l) (insert (format "%s\n" l))) php-my-functions)
        (write-file complete-functions-file))
    )
  )

(defconst php-super-global-variable
  (sort
   (list "$_SERVER" "$_GET" "$_POST" "$_FILES" "$_REQUEST" "$_SESSION" "$_ENV"
         "$_COOKIE" "$php_errormsg" "$HTTP_RAW_POST_DATA" "$http_response_header"
         ) #'(lambda (a b) (> (length a) (length b)))))

(defconst php-magical-constant
  (sort
   (list "__LINE__" "__FILE__" "__DIR__" "__FUNCTION__" "__CLASS__" "__METHOD__"
         ) #'(lambda (a b) (> (length a) (length b)))))

(defconst php-defined-constant
  (sort
   (list "PHP_VERSION" "PHP_MAJOR_VERSION" "PHP_MINOR_VERSION" "PHP_RELEASE_VERSION"
         "PHP_VERSION_ID" "PHP_EXTRA_VERSION" "PHP_ZTS" "PHP_DEBUG" "PHP_OS"
         "PHP_SAPI" "PHP_EOL" "PHP_INT_MAX" "PHP_INT_SIZE" "DEFAULT_INCLUDE_PATH"
         "PEAR_INSTALL_DIR" "PEAR_EXTENSION_DIR" "PHP_EXTENSION_DIR" "PHP_PREFIX"
         "PHP_BINDIR" "PHP_LIBDIR" "PHP_DATADIR" "PHP_SYSCONFDIR" "PHP_LOCALSTATEDIR"
         "PHP_CONFIG_FILE_PATH" "PHP_CONFIG_FILE_SCAN_DIR" "PHP_SHLIB_SUFFIX"
         "PHP_OUTPUT_HANDLER_START" "PHP_OUTPUT_HANDLER_CONT" "PHP_OUTPUT_HANDLER_END"
         "E_ERROR" "E_WARNING" "E_PARSE" "E_NOTICE" "E_CORE_ERROR" "E_CORE_WARNING"
         "E_COMPILE_ERROR" "E_COMPILE_WARNING" "E_USER_ERROR" "E_USER_WARNING"
         "E_USER_NOTICE" "E_ALL" "E_STRICT" "__COMPILER_HALT_OFFSET__"
         "EXTR_OVERWRITE" "EXTR_SKIP" "EXTR_PREFIX_SAME" "EXTR_PREFIX_ALL"
         "EXTR_PREFIX_INVALID" "EXTR_PREFIX_IF_EXISTS" "EXTR_IF_EXISTS"
         "SORT_ASC" "SORT_DESC" "SORT_REGULAR" "SORT_NUMERIC" "SORT_STRING"
         "CASE_LOWER" "CASE_UPPER" "COUNT_NORMAL" "COUNT_RECURSIVE" "ASSERT_ACTIVE"
         "ASSERT_CALLBACK" "ASSERT_BAIL" "ASSERT_WARNING" "ASSERT_QUIET_EVAL"
         "CONNECTION_ABORTED" "CONNECTION_NORMAL" "CONNECTION_TIMEOUT"
         "INI_USER" "INI_PERDIR" "INI_SYSTEM" "INI_ALL" "M_E" "M_LOG2E" "M_LOG10E"
         "M_LN2" "M_LN10" "M_PI" "M_PI_2" "M_PI_4" "M_1_PI" "M_2_PI" "M_2_SQRTPI"
         "M_SQRT2" "M_SQRT1_2" "CRYPT_SALT_LENGTH" "CRYPT_STD_DES" "CRYPT_EXT_DES"
         "CRYPT_MD5" "CRYPT_BLOWFISH" "DIRECTORY_SEPARATOR" "SEEK_SET"
         "SEEK_CUR" "SEEK_END" "LOCK_SH" "LOCK_EX" "LOCK_UN" "LOCK_NB" "HTML_SPECIALCHARS"
         "HTML_ENTITIES" "ENT_COMPAT" "ENT_QUOTES" "ENT_NOQUOTES" "INFO_GENERAL"
         "INFO_CREDITS" "INFO_CONFIGURATION" "INFO_MODULES" "INFO_ENVIRONMENT"
         "INFO_VARIABLES" "INFO_LICENSE" "INFO_ALL" "CREDITS_GROUP" "CREDITS_GENERAL"
         "CREDITS_SAPI" "CREDITS_MODULES" "CREDITS_DOCS" "CREDITS_FULLPAGE"
         "CREDITS_QA" "CREDITS_ALL" "STR_PAD_LEFT" "STR_PAD_RIGHT" "STR_PAD_BOTH"
         "PATHINFO_DIRNAME" "PATHINFO_BASENAME" "PATHINFO_EXTENSION" "PATH_SEPARATOR"
         "CHAR_MAX" "LC_CTYPE" "LC_NUMERIC" "LC_TIME" "LC_COLLATE" "LC_MONETARY"
         "LC_ALL" "LC_MESSAGES" "ABDAY_1" "ABDAY_2" "ABDAY_3" "ABDAY_4" "ABDAY_5"
         "ABDAY_6" "ABDAY_7" "DAY_1" "DAY_2" "DAY_3" "DAY_4" "DAY_5" "DAY_6"
         "DAY_7" "ABMON_1" "ABMON_2" "ABMON_3" "ABMON_4" "ABMON_5" "ABMON_6"
         "ABMON_7" "ABMON_8" "ABMON_9" "ABMON_10" "ABMON_11" "ABMON_12" "MON_1"
         "MON_2" "MON_3" "MON_4" "MON_5" "MON_6" "MON_7" "MON_8" "MON_9" "MON_10"
         "MON_11" "MON_12" "AM_STR" "PM_STR" "D_T_FMT" "D_FMT" "T_FMT" "T_FMT_AMPM"
         "ERA" "ERA_YEAR" "ERA_D_T_FMT" "ERA_D_FMT" "ERA_T_FMT" "ALT_DIGITS"
         "INT_CURR_SYMBOL" "CURRENCY_SYMBOL" "CRNCYSTR" "MON_DECIMAL_POINT"
         "MON_THOUSANDS_SEP" "MON_GROUPING" "POSITIVE_SIGN" "NEGATIVE_SIGN"
         "INT_FRAC_DIGITS" "FRAC_DIGITS" "P_CS_PRECEDES" "P_SEP_BY_SPACE"
         "N_CS_PRECEDES" "N_SEP_BY_SPACE" "P_SIGN_POSN" "N_SIGN_POSN" "DECIMAL_POINT"
         "RADIXCHAR" "THOUSANDS_SEP" "THOUSEP" "GROUPING" "YESEXPR" "NOEXPR"
         "YESSTR" "NOSTR" "CODESET" "LOG_EMERG" "LOG_ALERT" "LOG_CRIT" "LOG_ERR"
         "LOG_WARNING" "LOG_NOTICE" "LOG_INFO" "LOG_DEBUG" "LOG_KERN" "LOG_USER"
         "LOG_MAIL" "LOG_DAEMON" "LOG_AUTH" "LOG_SYSLOG" "LOG_LPR" "LOG_NEWS"
         "LOG_UUCP" "LOG_CRON" "LOG_AUTHPRIV" "LOG_LOCAL0" "LOG_LOCAL1"
         "LOG_LOCAL2" "LOG_LOCAL3" "LOG_LOCAL4" "LOG_LOCAL5" "LOG_LOCAL6"
         "LOG_LOCAL7" "LOG_PID" "LOG_CONS" "LOG_ODELAY" "LOG_NDELAY" "LOG_NOWAIT"
         ) #'(lambda (a b) (> (length a) (length b)))))

(defconst php-reserved-keywords
  (sort
   (list "abstract" "and" "array" "as" "break" "case" "catch" "cfunction" "class"
         "clone" "const" "continue" "declare" "default" "do" "else" "elseif"
         "enddeclare" "endfor" "endforeach" "endif" "endswitch" "endwhile"
         "extends" "final" "for" "foreach" "function" "global" "goto" "if"
         "implements" "interface" "instanceof" "namespace" "new" "old_function"
         "or" "private" "protected" "public" "static" "switch" "this" "throw"
         "try" "use" "var" "while" "xor" "__CLASS__" "__DIR__" "__FILE__" "__FUNCTION__"
         "__METHOD__" "__NAMESPACE__" "die" "echo" "empty" "exit" "eval" "include"
         "include_once" "isset" "list" "require" "require_once" "return"
         ) #'(lambda (a b) (> (length a) (length b)))))

(defvar ac-source-php
  '((candidates
     . (lambda ()
         (all-completions ac-target (append php-my-functions
                                            php-super-global-variable
                                            php-magical-constant
                                            php-defined-constant
                                            php-reserved-keywords)))
     )) "Source for PHP 5.2.8 keywords.")

(add-hook 'php-mode-hook
          (lambda ()
            (make-local-variable 'ac-sources)
            (setq ac-sources '(ac-source-php
                               ;;ac-source-yasnippet
                               ac-source-abbrev
                               ac-source-files-in-current-dir
                               ac-source-words-in-buffer
                               ac-source-filename))))

(provide 'autocompletion-php-functions)
;;; autocompletion-php-functions.el ends here

