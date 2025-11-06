select
	transaction_id,
	montant,
	date_transaction,
	description
from
	transaction
where
	date_transaction > '2023-10-16'
	and montant > 400000
order by
	date_transaction desc;

select
	B.nom_banque,
	CP.numero_compte,
	CP.solde,
	C.prenom
from
	banque B
inner join compte CP
on
	B.banque_id = CP.banque_id
inner join client C on
	C.client_id = CP.client_id
where
	solde > 500000
order by
	CP.solde desc;

select
	C.nom,
	C.prenom,
	B.nom_banque,
	B.ville_siege,
	CP type_compte
from
	client C
inner join compte CP
on
	C.client_id = CP.client_id
inner join banque B
on
	B.banque_id = CP.banque_id
where
	type_compte = 'Épargne';

select
	B.nom_banque,
	count(distinct C.client_id) as nombre_clients,
	round (avg(CP.solde) )as solde_moyen
from
	compte CP
inner join banque B
on
	CP.banque_id = B.banque_id
inner join client C on
	CP.client_id = C.client_id
group by
	B.nom_banque
order by
	solde_moyen desc;

select
	type_transaction,
	sum(montant)
from
	transaction
group by
	type_transaction;

select
	C.nom,
	C.prenom as nom_complet,
	count(CP.compte_id) as nombre_de_compte
from
	client C
inner join compte CP
on
	C.client_id = CP.client_id
group by
	C.client_id,
	C.prenom,
	C.nom
having
	count(CP.compte_id)> 1 ;

analyse des Soldes
 
select
	C.compte_id,
	C.numero_compte,
	C.solde as solde_initial,
	(
	select
		SUM(
            case
                when T.type_transaction = 'Dépôt' then T.montant
                else -T.montant -- Retrait et Virement
            end
        )
	from
		transaction T
	where
		T.compte_id = C.compte_id
    ) as mouvement_total,
	C.solde + (
	select
		SUM(
            case
                when T2.type_transaction = 'Dépôt' then T2.montant
                else -T2.montant
            end
        )
	from
		transaction T2
	where
		T2.compte_id = C.compte_id
    ) as solde_final
from
	Compte C
order by
	solde_final desc;

analyse du Volume par Banque et par Client (Requêtes de Reporting)

select
	B.nom_banque,
	COUNT(T.transaction_id) as nombre_transactions_total,
	SUM(T.montant) as montant_cumule_transactions
from
	Banque B
join Compte C on
	B.banque_id = C.banque_id
join transaction T on
	C.compte_id = T.compte_id
group by
	B.nom_banque
order by
	montant_cumule_transactions desc;

Top 3 des Clients par Volume de Dépôt
select
	CL.nom,
	CL.prenom,
	COUNT(T.transaction_id) as nombre_depots,
	SUM(T.montant) as total_depots
from
	Client CL
join Compte C on
	CL.client_id = C.client_id
join transaction T on
	C.compte_id = T.compte_id
where
	T.type_transaction = 'Dépôt'
group by
	CL.nom,
	CL.prenom
order by
	total_depots desc
limit 3;