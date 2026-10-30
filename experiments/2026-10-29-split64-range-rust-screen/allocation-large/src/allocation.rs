pub(crate) mod allocation {
    use std::alloc::{GlobalAlloc, Layout, System};
    use std::cell::Cell;

    #[derive(Clone, Copy, Debug, Default)]
    pub(crate) struct Counts {
        pub allocations: usize,
        pub bytes: usize,
        pub max_alignment: usize,
        pub deallocations: usize,
        pub freed_bytes: usize,
    }
    thread_local! {
        static COUNTS: Cell<Option<Counts>> = const { Cell::new(None) };
    }
    struct AuditAllocator;
    #[global_allocator]
    static ALLOCATOR: AuditAllocator = AuditAllocator;

    fn allocated(layout: Layout) {
        let _ = COUNTS.try_with(|slot| {
            if let Some(mut counts) = slot.get() {
                counts.allocations += 1;
                counts.bytes += layout.size();
                counts.max_alignment = counts.max_alignment.max(layout.align());
                slot.set(Some(counts));
            }
        });
    }
    unsafe impl GlobalAlloc for AuditAllocator {
        unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
            allocated(layout);
            System.alloc(layout)
        }
        unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
            allocated(layout);
            System.alloc_zeroed(layout)
        }
        unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
            let _ = COUNTS.try_with(|slot| {
                if let Some(mut counts) = slot.get() {
                    counts.deallocations += 1;
                    counts.freed_bytes += layout.size();
                    slot.set(Some(counts));
                }
            });
            System.dealloc(ptr, layout);
        }
    }
    pub(crate) fn measure<T>(f: impl FnOnce() -> T) -> (T, Counts) {
        struct Reset;
        impl Drop for Reset {
            fn drop(&mut self) {
                COUNTS.with(|slot| slot.set(None));
            }
        }
        COUNTS.with(|slot| {
            assert!(slot.get().is_none());
            slot.set(Some(Counts::default()));
        });
        let reset = Reset;
        let value = f();
        let counts = COUNTS.with(|slot| slot.take().unwrap());
        drop(reset);
        (value, counts)
    }
}
