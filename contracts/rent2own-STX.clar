;; ------------------------------------------------------------
;; Rent2Own-STX
;; A decentralized rent-to-own contract that allows tenants to 
;; rent assets with equity buildup toward ownership.
;; ------------------------------------------------------------

(define-trait rent2own-trait
  (
    ;; register an asset for rent-to-own
    (register-asset (principal uint uint uint) (response bool uint))
    ;; pay rent (tenant pays rent + equity)
    (pay-rent (uint) (response bool uint))
    ;; claim ownership if equity >= purchase price
    (claim-ownership () (response bool uint))
    ;; reclaim asset in case of default
    (reclaim-asset (principal) (response bool uint))
  )
)

;; ------------------------------------------------------------
;; Data Maps
;; ------------------------------------------------------------

(define-data-var asset-counter uint u0)

;; Asset structure: 
;; owner, tenant, rent-amount, purchase-price, equity-built, active?
(define-map assets 
  uint 
  {
    owner: principal,
    tenant: (optional principal),
    rent-amount: uint,
    purchase-price: uint,
    equity: uint,
    active: bool
  }
)

;; ------------------------------------------------------------
;; Core Functions
;; ------------------------------------------------------------

(define-public (register-asset (owner principal) (rent-amount uint) (purchase-price uint) (asset-id uint))
  (begin
    (map-insert assets asset-id {
      owner: owner,
      tenant: none,
      rent-amount: rent-amount,
      purchase-price: purchase-price,
      equity: u0,
      active: true
    })
    (ok true)
  )
)

(define-public (pay-rent (asset-id uint))
  (let
    (
      (asset (map-get? assets asset-id))
    )
    (match asset
      asset-data
        (begin
          (if (is-some (get tenant asset-data))
              (begin
                ;; simulate rent payment: equity increases by 50% of rent
                (map-set assets asset-id {
                  owner: (get owner asset-data),
                  tenant: (get tenant asset-data),
                  rent-amount: (get rent-amount asset-data),
                  purchase-price: (get purchase-price asset-data),
                  equity: (+ (get equity asset-data) (/ (get rent-amount asset-data) u2)),
                  active: true
                })
                (ok true)
              )
              (err u100)) ;; no tenant assigned
        )
      (err u101) ;; asset not found
    )
  )
)

(define-public (claim-ownership (asset-id uint))
  (let
    (
      (asset (map-get? assets asset-id))
    )
    (match asset
      asset-data
        (if (>= (get equity asset-data) (get purchase-price asset-data))
            (begin
              ;; ownership transferred to tenant
              (map-set assets asset-id {
                owner: tx-sender, ;; cleared
                tenant: (get tenant asset-data),
                rent-amount: (get rent-amount asset-data),
                purchase-price: (get purchase-price asset-data),
                equity: (get equity asset-data),
                active: false
              })
              (ok true)
            )
            (err u200)) ;; insufficient equity
      (err u201) ;; asset not found
    )
  )
)

(define-public (reclaim-asset (asset-id uint))
  (let
    (
      (asset (map-get? assets asset-id))
    )
    (match asset
      asset-data
        (begin
          (map-set assets asset-id {
            owner: (get owner asset-data),
            tenant: none,
            rent-amount: (get rent-amount asset-data),
            purchase-price: (get purchase-price asset-data),
            equity: u0,
            active: true
          })
          (ok true)
        )
      (err u300) ;; asset not found
    )
  )
)

;; ------------------------------------------------------------
;; Helper Functions
;; ------------------------------------------------------------

(define-read-only (get-asset (asset-id uint))
  (map-get? assets asset-id)
)
