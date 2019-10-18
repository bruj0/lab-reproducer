path "gts_test_collection" {{
capabilities = ["list"]
}}

path "gts_test_collection/data/NoApproval/*" {{
capabilities = ["read"]
}}

path "gts_test_collection/data/WithApproval/*" {{
capabilities = ["read"]
control_group = {{
        factor "approvers" {{
            identity {{
                group_names = ["approver-group"]
                approvals = 1
            }}
        }}
    }}
}}
path "gts_test_collection/metadata/*" {{
capabilities = ["read","list"]
}}

path "gts_test_collection/*" {{
capabilities = ["list"]
}}