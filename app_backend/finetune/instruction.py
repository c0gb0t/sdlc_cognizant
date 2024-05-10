categories=['train','station','suggestion','enquiry','staff','website']
instruction=f"""Identify the following from the complaint:
1)category of the complaint from the following categories:{categories.__str__()}.
2)a priority for the complaint.
3)extract attributes from the complaint.
4)identify sentiment from the complaint.
return the output in format: tags:[],priority:[],attributes:[],sentiment:[]
"""