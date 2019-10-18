path "gts_test_collection" {{
capabilities = ["list"]
}}

path "sys/control-group/authorize" {{
capabilities = ["create","update"]
}}

path "gts_test_collection/metadata/*" {{
capabilities = ["read","list"]
}}

path "gts_test_collection/*" {{
capabilities = ["list"]
}}