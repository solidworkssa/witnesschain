;; WitnessChain Clarity Contract
;; Digital notary and witness verification.


(define-map records
    (buff 32)
    {
        witness: principal,
        timestamp: uint
    }
)

(define-public (notarize (hash (buff 32)))
    (begin
        (asserts! (is-none (map-get? records hash)) (err u100))
        (map-set records hash {witness: tx-sender, timestamp: block-height})
        (ok true)
    )
)

