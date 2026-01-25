;; WitnessChain - Digital notary

(define-data-var attestation-counter uint u0)

(define-map attestations uint {
    attestor: principal,
    document-hash: (buff 32),
    timestamp: uint,
    witness-count: uint
})

(define-map witnesses {attestation-id: uint, witness: principal} bool)

(define-public (create-attestation (document-hash (buff 32)))
    (let ((attestation-id (var-get attestation-counter)))
        (map-set attestations attestation-id {
            attestor: tx-sender,
            document-hash: document-hash,
            timestamp: block-height,
            witness-count: u0
        })
        (var-set attestation-counter (+ attestation-id u1))
        (ok attestation-id)))

(define-public (add-witness (attestation-id uint))
    (let ((attestation (unwrap! (map-get? attestations attestation-id) (err u100))))
        (map-set witnesses {attestation-id: attestation-id, witness: tx-sender} true)
        (ok (map-set attestations attestation-id 
            (merge attestation {witness-count: (+ (get witness-count attestation) u1)})))))

(define-read-only (get-attestation (attestation-id uint))
    (ok (map-get? attestations attestation-id)))

(define-read-only (verify-document (attestation-id uint) (document-hash (buff 32)))
    (match (map-get? attestations attestation-id)
        attestation (ok (is-eq (get document-hash attestation) document-hash))
        (ok false)))
