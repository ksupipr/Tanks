
-define(LOG(M1, M2), io:format(M1, M2)).

% база данных пользователей
-define(DB_CONNECT_test, [{0, { "192.168.45.66", 
                           "reitars-web-interface", 
                           "rwiuser_pass", 
                           [{database, "tanks2"}, {port,     6432}]
                         }
                     },
                     {1, { "192.168.45.66", 
                           "reitars-web-interface", 
                           "rwiuser_pass", 
                           [{database, "Tanks"}, {port,     6432}]
                         }
                     },
                     {2, { "192.168.45.66", 
                           "reitars-web-interface", 
                           "rwiuser_pass", 
                           [{database, "tanks2"}, {port,     6432}]
                         }
                     },
                     {3, { "192.168.45.66", 
                           "reitars-web-interface", 
                           "rwiuser_pass", 
                           [{database, "tanks3"}, {port,     6432}]
                         }
                     },
                     {4, { "192.168.45.66", 
                           "reitars-web-interface", 
                           "rwiuser_pass", 
                           [{database, "tanks4"}, {port,     6432}]
                         }
                     },
                     {5, { "192.168.45.66", 
                           "reitars-web-interface", 
                           "rwiuser_pass", 
                           [{database, "tanks4"}, {port,     6432}]
                         }
                     }
                    ]).


-define(DB_CONNECT, [{0, { "192.168.1.6", 
                           "xlab-web-interface", 
                           "xwiuser_pass8dfbf2456", 
                           [{database, "Tanks"}, {port,     6432}]
                         }
                     },
                     {1, { "192.168.1.6", 
                           "xlab-web-interface", 
                           "xwiuser_pass8dfbf2456", 
                           [{database, "Tanks"}, {port,     6432}]
                         }
                     },
                     {2, { "192.168.1.6", 
                           "xlab-web-interface", 
                           "xwiuser_pass8dfbf2456", 
                           [{database, "tanks2"}, {port,     6432}]
                         }
                     },
                     {3, { "192.168.1.6", 
                           "xlab-web-interface", 
                           "xwiuser_pass8dfbf2456", 
                           [{database, "tanks3"}, {port,     6432}]
                         }
                     },
                     {4, { "192.168.1.2", 
                           "xlab-web-interface", 
                           "xwiuser_pass8dfbf2456", 
                           [{database, "tanks4"}, {port,     6432}]
                         }
                     },
                     {5, { "192.168.1.2", 
                           "xlab-web-interface", 
                           "xwiuser_pass8dfbf2456", 
                           [{database, "tanks5"}, {port,     6432}]
                         }
                     }
                    ]).